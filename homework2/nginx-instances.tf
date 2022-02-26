provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "whiskey1" {
  ami = "ami-033b95fb8079dc481"
  instance_type = var.web_instance_type
  availability_zone = "us-east-1a"
  subnet_id = aws_subnet.public-az-1a.id
  key_name = "linux-vm"
  vpc_security_group_ids = [aws_security_group.web-access-whiskey1.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 12
    volume_type =  "gp2"
    delete_on_termination = true
  }
  ebs_block_device {
  device_name           = "/dev/sda1"
  volume_size           = "10"
  volume_type           = "gp2"
  encrypted             = true
  }
  tags = {
        Name = "web-whiskey1"
        Owner = "ItzickS"
        purpose = "whiskey"
  }
  user_data = <<EOF
                #!/bin/bash
                sudo sudo amazon-linux-extras install -y nginx1
                sudo systemctl start ngnix
                echo "<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en'><head><title> Welcome to Grandpa's Whiskey </title></head><body><h1> Welcome to Grandpa's Whiskey </h1></body></html>" | sudo tee /usr/share/nginx/html/index.html
                sudo systemctl restart nginx.service
              EOF
}

resource "aws_instance" "whiskey2" {
  ami = "ami-033b95fb8079dc481"
  instance_type = var.web_instance_type
  availability_zone = "us-east-1c"
  subnet_id = aws_subnet.public-az-1c.id
  key_name = "linux-vm"
  vpc_security_group_ids = [aws_security_group.web-access-whiskey2.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 12
    volume_type =  "gp2"
    delete_on_termination = true
  }
  ebs_block_device {
  device_name           = "/dev/sda1"
  volume_size           = "10"
  volume_type           = "gp2"
  encrypted             = true
  }
  tags = {
        Name = "web-whiskey2"
        Owner = "ItzickS"
        purpose = "whiskey"
  }
  user_data = <<EOF
                #!/bin/bash
                sudo sudo amazon-linux-extras install -y nginx1
                sudo systemctl start ngnix
                echo "<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en'><head><title> Welcome to Grandpa's Whiskey </title></head><body><h1> Welcome to Grandpa's Whiskey </h1></body></html>" | sudo tee /usr/share/nginx/html/index.html
                sudo systemctl restart nginx.service
              EOF
}

resource "aws_security_group" "web-access-whiskey1" {
  vpc_id = aws_vpc.whiskey_vpc.id
  name = "web-access-whiskey1"
  tags = {
        Name = "Web-access-whiskey1-${aws_vpc.whiskey_vpc.id}"
  }
}

resource "aws_security_group_rule" "allow_http_anywhere-whiskey1" {
  description = "Allow HTTP from anywhere"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-access-whiskey1.id
}

resource "aws_security_group_rule" "allow_ssh_anywhere-whiskey1" {
  description = "Allow SSH from anywhere"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-access-whiskey1.id
}

resource "aws_security_group_rule" "web_outbound-all-whiskey1" {
  description = "Allow all to anywhere"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-access-whiskey1.id
}


resource "aws_security_group" "web-access-whiskey2" {
  vpc_id = aws_vpc.whiskey_vpc.id
  name = "web-access-whiskey2"
  tags = {
        Name = "Web-access-whiskey2-${aws_vpc.whiskey_vpc.id}"
  }
}

resource "aws_security_group_rule" "allow_http_anywhere-whiskey2" {
  description = "Allow HTTP from anywhere"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-access-whiskey2.id
}

resource "aws_security_group_rule" "allow_ssh_anywhere-whiskey2" {
  description = "Allow SSH from anywhere"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-access-whiskey2.id
}

resource "aws_security_group_rule" "web_outbound-all-whiskey2" {
  description = "Allow all to anywhere"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-access-whiskey2.id
}