locals {
my-nginx-userdata = <<USERDATA
 #!/bin/bash
 sudo sudo amazon-linux-extras install -y nginx1
 sudo systemctl start ngnix
 echo "<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en'><head><title> Welcome to Grandpa's Whiskey </title></head><body><h1> Welcome to Grandpa's Whiskey </h1></body></html> $(hostname)" | sudo tee /usr/share/nginx/html/index.html
 sudo systemctl restart nginx.service
 echo "BUCKET=itzick-opsschool-whiskey
 sudo gzip -c /var/log/nginx/access.log > /tmp/access.log.gz
 aws s3 cp /tmp/access.log.gz s3://$BUCKET/access_`date +%Y%m%dT%H%M%SZ`_$PUBLIC_IP.log.gz --region us-east-1 " | sudo tee /home/ec2-user/logs.sh
 sudo chmod +x /home/ec2-user/logs.sh
 ./logs.sh
USERDATA
}