# VPC creation
resource "aws_vpc" "whiskey_vpc" {
    cidr_block = var.vpc_cidr_block

    tags = {
      Name = "${var.env_prefix}-vpc"
    }
}

# Public Subnets for web servers, NAT Gateway and Internet Gateway
resource "aws_subnet" "public-az-1a" {
    vpc_id = aws_vpc.whiskey_vpc.id
    cidr_block = var.public_subnet_az_1a_cidr_block
    availability_zone = "us-east-1a"
    tags = {
      Name = "${var.env_prefix}-public_subnet-1a"
    }
}

resource "aws_subnet" "public-az-1c" {
    vpc_id = aws_vpc.whiskey_vpc.id
    cidr_block = var.public_subnet_az_1c_cidr_block
    availability_zone = "us-east-1c"
    tags = {
      Name = "${var.env_prefix}-public_subnet-1c"
    }
}

# Private Subnet for DB Servers
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.whiskey_vpc.id
    cidr_block = var.private_subnet_cidr_block
    availability_zone = "us-east-1b"
    tags = {
      Name = "${var.env_prefix}-private_subnet"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.whiskey_vpc.id
  
  tags = {
      Name = "${var.env_prefix}-IGW"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "eip_nat" {
  tags = {
    Name = "${var.env_prefix}-NAT_EIP"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id = aws_subnet.public-az-1a.id
  depends_on = [aws_internet_gateway.igw]
}

# Routes
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.whiskey_vpc.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.whiskey_vpc.id
}

resource "aws_route_table_association" "public1" {
  subnet_id = aws_subnet.public-az-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id = aws_subnet.public-az-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "private" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}