#!/bin/bash
sudo mv /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html.bak
echo "<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en'><head><title> Welcome to Grandpa's Whiskey </title></head><body><h1> Welcome to Grandpa's Whiskey </h1></body></html>" | sudo tee -a /usr/share/nginx/html/index.html
sudo systemctl restart nginx.service
