#!/usr/bin/env bash

sudo apt-get remove -y nginx
sudo apt-get update
sudo apt-get install -y nginx
sudo mv /home/ubuntu/default /etc/nginx/sites-available/default
sudo systemctl restart nginx
