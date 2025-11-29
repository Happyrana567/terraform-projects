#!/bin/bash
apt update -y
apt install -y nginx

cat <<EOF > /var/www/html/index.html
<html>
  <head>
    <title>Project 2 - Terraform Deployment</title>
  </head>
  <body style="font-family: Arial; text-align: center; margin-top: 50px;">
    <h1>Hello from Project 2!</h1>
    <h3>Terraform + AWS + Ubuntu + Nginx</h3>
    <p>This page is deployed automatically using User Data.</p>
  </body>
</html>
EOF

systemctl enable nginx
systemctl restart nginx

