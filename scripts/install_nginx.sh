#!/bin/bash

yum update -y
yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo "This is a test page for Nginx installed via script." > /usr/share/nginx/html/index.html
