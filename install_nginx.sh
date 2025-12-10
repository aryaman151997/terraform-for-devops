#!/bin/bash 
sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

echo "<h1> terraform making an nginx server </h1>" | sudo tee /var/www/html/index.html