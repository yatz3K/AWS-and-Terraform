variable "env_prefix" {
    default = "whiskey"
}

variable "vpc_cidr_block" {
    default = "192.168.0.0/16"
    type = string
}

variable "public_subnet_az_1a_cidr_block" {
    default = "192.168.20.0/24"
    type = string
}

variable "public_subnet_az_1c_cidr_block" {
    default = "192.168.30.0/24"
    type = string
}

variable "private_subnet_cidr_block" {
    default = "192.168.10.0/24"
    type = string
}

variable "web_instance_type" {
  type = string
  default = "t3.micro"
}

variable "db_instance_type" {
  type = string
  default = "t2.micro"
}