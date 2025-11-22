#!/bin/bash

# Update and install Nginx 
apt update -y 
apt install -y nginx 

# Start & enable nginx 
systemctl enable nginx 
systemctl start nginx 

# Write multi-line HTML content 
cat <<EOF > /var/www/html/index.html 
<h1>Welcome to Project-1 Web Server</h1> 
<p>This EC2 instance is configured using Terraform and nginx_setup.sh.</p> 
EOF
