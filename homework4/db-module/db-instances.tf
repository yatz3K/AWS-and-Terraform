resource "aws_instance" "db_whiskey" {
    count = var.DB_instances_count
    ami = var.ami
    instance_type = var.db_instance_type
    key_name = var.key_name
    subnet_id = var.private_subnets_id[count.index]
    associate_public_ip_address = false
    vpc_security_group_ids = [aws_security_group.DB_instnaces_access.id]

    tags = {
        "Name" = "DB"
    }
}

resource "aws_security_group" "DB_instnaces_access" {
  vpc_id = var.vpc_id
  name   = "DB-access"

  tags = {
    "Name" = "DB-access-${var.vpc_id}"
  }
}

resource "aws_security_group_rule" "DB_ssh_acess" {
  description       = "allow ssh access from anywhere"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.DB_instnaces_access.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "DB_outbound_anywhere" {
  description       = "allow outbound traffic to anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.DB_instnaces_access.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}