# Nginx - Basic Setup (Ubuntu 25.04)

## Install
sudo apt update
sudo apt install -y nginx

## Service control
sudo systemctl status nginx
sudo systemctl enable nginx

## Test
curl -I http://localhost

## Notes
- Nginx is installed as a systemd service
- Default site is under /etc/nginx/sites-available/default
