#!/bin/bash
set -e

# =========================
# Validação do SO
# =========================
. /etc/os-release

if [[ "$ID" != "debian" ]]; then
  echo "Este script suporta apenas Debian. Detectado: $ID"
  exit 1
fi

echo "== Debian detectado: $VERSION_CODENAME =="

# =========================
# Atualização do sistema
# =========================
echo "== Atualizando sistema =="
apt update -y


# =========================
# Pacotes base
# =========================
echo "== Instalando pacotes base =="
apt install -y \
  curl \
  wget \
  ca-certificates \
  gnupg \
  lsb-release

# =========================
# Utilitários
# =========================
echo "== Instalando utilitários =="
apt install -y htop tree

# =========================
# UFW (Firewall)
# =========================
echo "== Instalando e configurando UFW =="
apt install -y ufw

ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80
ufw allow 443
ufw --force enable

# =========================
# Fail2Ban
# =========================
echo "== Instalando Fail2Ban =="
apt install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban

# =========================
# NGINX
# =========================
echo "== Instalando NGINX =="
apt install -y nginx
systemctl enable nginx
systemctl start nginx

# =========================
# MariaDB
# =========================
echo "== Instalando MariaDB Server =="
apt install -y mariadb-server
systemctl enable mariadb
systemctl start mariadb

# =========================
# PHP (NGINX + FPM)
# =========================
echo "== Instalando PHP-FPM e extensões =="
apt install -y \
  php-cli \
  php-fpm \
  php-mysql \
  php-curl \
  php-gd \
  php-mbstring \
  php-xml \
  php-zip \
  php-bcmath \
  php-redis

PHP_SOCK=$(find /run/php/ -name "php*-fpm.sock" | head -n 1)

sed -i "s/index index.html/index index.php index.html/" /etc/nginx/sites-available/default

sed -i "s|#location ~ \\.php$ {|location ~ \\.php$ {|g" /etc/nginx/sites-available/default
sed -i "s|#\tinclude snippets/fastcgi-php.conf;|\tinclude snippets/fastcgi-php.conf;|g" /etc/nginx/sites-available/default
sed -i "s|#\tfastcgi_pass unix:/run/php/php.*-fpm.sock;|\tfastcgi_pass unix:${PHP_SOCK};|g" /etc/nginx/sites-available/default
sed -i "s|#}|}|g" /etc/nginx/sites-available/default

nginx -t && systemctl reload nginx

# =========================
# Redis
# =========================
echo "== Instalando Redis =="
apt install -y redis-server
systemctl enable redis-server
systemctl start redis-server

sed -i "s/^bind .*/bind 127.0.0.1 ::1/" /etc/redis/redis.conf
systemctl restart redis-server

# =========================
# Finalização
# =========================
echo "===================================="
echo "Stack Debian instalada com sucesso:"
echo "- UFW + Fail2Ban"
echo "- NGINX + PHP-FPM"
echo "- MariaDB"
echo "- Redis"
echo "- htop / tree"
echo "===================================="
