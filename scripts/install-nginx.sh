#!/usr/bin/env bash
set -e

echo "Updating system..."
sudo apt update

echo "Installing nginx..."
sudo apt install -y nginx

echo "Enabling nginx service..."
sudo systemctl enable --now nginx

if systemctl is-active --quiet nginx; then
  echo "Nginx is running successfully."
else
  echo "ERROR: Nginx is not running."
  exit 1
fi
