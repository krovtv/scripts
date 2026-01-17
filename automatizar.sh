#!/bin/bash

set -e

echo "== Atualizando sistema =="
apt update -y 

echo "== Instalando pacotes base =="
apt install -y \
  curl \
  wget \
  ca-certificates \
  lsb-release \
  gnupg \
  software-properties-common

echo "== Instalando utilitários =="
apt install -y htop tree

echo "== Instalando UFW (Firewall) =="
apt install -y ufw

ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80
ufw allow 443
ufw --force enable

echo "== Instalando Fail2Ban =="
apt install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban

echo "== Instalando NGINX =="
apt install -y nginx
systemctl enable nginx
systemctl start nginx

echo "== Instalando MariaDB Server =="
apt install -y mariadb-server
systemctl enable mariadb
systemctl start mariadb

echo "== Instalando PHP e dependências =="
apt install -y \
  php \
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

echo "== Ajustando NGINX para PHP-FPM =="
PHP_SOCK=$(find /run/php/ -name "php*-fpm.sock" | head -n 1)

sed -i "s|index index.html index.htm;|index index.php index.html index.htm;|g" /etc/nginx/sites-available/default

sed -i "s|#location ~ \\.php$ {|location ~ \\.php$ {|g" /etc/nginx/sites-available/default
sed -i "s|#\tinclude snippets/fastcgi-php.conf;|\tinclude snippets/fastcgi-php.conf;|g" /etc/nginx/sites-available/default
sed -i "s|#\tfastcgi_pass unix:/run/php/php7.4-fpm.sock;|\tfastcgi_pass unix:${PHP_SOCK};|g" /etc/nginx/sites-available/default
sed -i "s|#}|}|g" /etc/nginx/sites-available/default

nginx -t && systemctl reload nginx

echo "== Instalando Redis =="
apt install -y redis-server
systemctl enable redis-server
systemctl start redis-server

echo "== Endurecendo Redis (bind local) =="
sed -i "s/^bind .*/bind 127.0.0.1 ::1/" /etc/redis/redis.conf
systemctl restart redis-server

echo "== Finalização =="
echo "Stack instalada com sucesso:"
echo "- UFW ativo"
echo "- Fail2Ban ativo"
echo "- NGINX + PHP-FPM"
echo "- MariaDB"
echo "- Redis"
echo "- htop / tree"
