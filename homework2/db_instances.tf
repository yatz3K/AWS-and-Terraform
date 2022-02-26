resource "aws_instance" "db_whiskey" {
  count = 2
  ami = "ami-033b95fb8079dc481"
  instance_type = var.db_instance_type
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.db-access.id]
  key_name = "linux-vm"
  associate_public_ip_address = false
  tags = {
        Name = "db-whiskey"
        Owner = "ItzickS"
        purpose = "whiskey"
  }
}

resource "aws_security_group" "db-access" {
  vpc_id = aws_vpc.whiskey_vpc.id
  name = "DB-access"

  tags = {
    Name = "DB-access-${aws_vpc.whiskey_vpc.id}"
  }
}

resource "aws_security_group_rule" "ssh-access" {
    description = "allow ssh from anywhere"
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.db-access.id
  
}

resource "aws_security_group_rule" "db-outbound-all" {
  description = "allow all to anywhere"  
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db-access.id
}