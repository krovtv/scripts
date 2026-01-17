# Linux Web Stack Automation (NGINX)

Script de automação para provisionamento de servidor Linux (Debian/Ubuntu) com stack web completa e hardening básico.

## Componentes instalados
- UFW (Firewall)
- Fail2Ban
- NGINX
- PHP-FPM + extensões
- MariaDB Server
- Redis
- htop / tree

## Requisitos
- Debian 11/12 ou Ubuntu 20.04+
- Execução como root

## Uso
```bash
chmod +x setup.sh
sudo ./setup.sh
