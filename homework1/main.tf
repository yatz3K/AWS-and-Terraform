provider "aws" {
  region  = "us-east-1"
}

resource "aws_security_group" "allow_http_ssh" {
  name = "allow_http_ssh"
  description = "Allow http and ssh from anywhere"
  ingress {
    description = "Allow HTTP from anywhere"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
        description = "Allow SSH from anywhere"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
   }
   egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        }
}

resource "aws_instance" "whiskey1" {
  ami = "ami-033b95fb8079dc481"
  instance_type = "t3.micro"
  key_name = "linux-vm"
  security_groups = [aws_security_group.allow_http_ssh.name]
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
  delete_on_termination = true
  }
  tags = {
        Name = "whiskey1"
        Owner = "ItzickS"
        purpose = "whiskey"
  }
 provisioner "file" {
    source = "/home/ec2-user/Homework1/scripts"
    destination = "/home/ec2-user/"
  }
 provisioner "remote-exec" {
    inline = [
        "sudo amazon-linux-extras install -y nginx1",
        "sudo systemctl start nginx",
        "sudo /usr/bin/chmod +x /home/ec2-user/scripts/script.sh",
        "sudo /home/ec2-user/scripts/script.sh"
    ]
 }
 connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("./linux-vm.pem")
        host = self.public_ip
 }
}

resource "aws_instance" "whiskey2" {
  ami = "ami-033b95fb8079dc481"
  instance_type = "t3.micro"
  key_name = "linux-vm"
  security_groups = [aws_security_group.allow_http_ssh.name]
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
  delete_on_termination = true
  }
  tags = {
        Name = "whiskey2"
        Owner = "ItzickS"
        purpose = "whiskey"
  }
  user_data = <<EOF
                #!/bin/bash
                sudo sudo amazon-linux-extras install -y nginx1
                sudo systemctl start ngnix
                sudo mv /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html.bak
                echo "<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en'><head><title> Welcome to Grandpa's Whiskey </title></head><body><h1> Welcome to Grandpa's Whiskey </h1></body></html>" | sudo tee -a /usr/share/nginx/html/index.html
                sudo systemctl restart nginx.service
              EOF
}

