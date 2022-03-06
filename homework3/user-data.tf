locals {
my-nginx-userdata = <<USERDATA
 #!/bin/bash
 sudo sudo amazon-linux-extras install -y nginx1
 sudo systemctl start ngnix
 echo "<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en'><head><title> Welcome to Grandpa's Whiskey </title></head><body><h1> Welcome to Grandpa's Whiskey $HOSTNAME </h1></body></html>" | sudo tee /usr/share/nginx/html/index.html
 sudo systemctl restart nginx.service
 sudo sh -c 'echo -e "#!/bin/bash \nsudo aws s3 cp /var/log/nginx/access.log  s3://itzick-opsschool-whiskey/logs/access_`date +%Y%m%dT%H%M%SZ`" > /etc/cron.hourly/s3.sh'
 sudo chmod +x /etc/cron.hourly/s3.sh
USERDATA
}