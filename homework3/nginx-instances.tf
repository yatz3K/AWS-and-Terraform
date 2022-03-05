resource "aws_instance" "nginx" {
  count                       = var.nginx_instances_count
  ami                         = var.ami
  instance_type               = var.nginx_instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public.*.id[count.index]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.nginx_instances_access.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.id
  user_data                   = local.my-nginx-userdata

  root_block_device {
    encrypted   = false
    volume_type = var.volumes_type
    volume_size = var.nginx_root_disk_size

  }

  ebs_block_device {
    encrypted   = true
    device_name = var.nginx_encrypted_disk_device_name
    volume_type = var.volumes_type
    volume_size = var.nginx_encrypted_disk_size
  }

  tags = {
     "Name" = "nginx-web-${regex(".$", data.aws_availability_zones.available.names[count.index])}"
  }
}

resource "aws_security_group" "nginx_instances_access" {
  vpc_id = aws_vpc.vpc.id
  name   = "nginx-access"

  tags = {
    "Name" = "nginx-access-${aws_vpc.vpc.id}"
  }
}

resource "aws_security_group_rule" "nginx_http_acess" {
  description       = "allow http access from anywhere"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.nginx_instances_access.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "nginx_ssh_acess" {
  description       = "allow ssh access from anywhere"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.nginx_instances_access.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "nginx_outbound_anywhere" {
  description       = "allow outbound traffic to anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nginx_instances_access.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}