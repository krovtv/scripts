# Automação de Provisionamento Linux

Script para automatizar a instalação de pacotes essenciais em servidores Linux, com foco em agilidade operacional, padronização de ambientes e redução de esforço manual da equipe de infraestrutura.

## Objetivo

- Acelerar o provisionamento de servidores
- Padronizar instalações entre ambientes
- Reduzir erros operacionais
- Facilitar reprodutibilidade e manutenção

## Pacotes Instalados

- UFW (Firewall)
- Fail2Ban
- NGINX
- PHP-FPM + extensões
- MariaDB Server
- Redis
- htop
- tree

## Sistemas Suportados

- Debian 11 / 12
- Ubuntu 20.04 ou superior

## Requisitos

- Execução como usuário **root**
- Servidor recém-instalado ou sem serviços conflitantes
- Acesso à internet para download dos pacotes

## Uso

```bash
chmod +x setup.sh
sudo ./setup.sh
