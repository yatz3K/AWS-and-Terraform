variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "nginx_instance_type" {
  description = "type of nginx ec2 instances"
  type = string
  default = "t3.micro"
}

variable "db_instance_type" {
  description = "type of db instances"
  type = string
  default = "t2.micro"
}

variable "key_name" {
  default     = "linux-vm"
  description = "The key name of the Key Pair to use for the instance"
  type        = string
}

variable "vpc_cidr_block" {
    default = "192.168.0.0/16"
    type = string
}

variable "private_subnet" {
  type    = list(string)
  default = ["192.168.10.0/24", "192.168.20.0/24"]
}

variable "public_subnet" {
  type    = list(string)
  default = ["192.168.30.0/24", "192.168.40.0/24"]
}

variable "nginx_instances_count" {
  default = 2
}

variable "DB_instances_count" {
  default = 2
}

variable "nginx_root_disk_size" {
  description = "The size of the root disk"
  default = "10"
}

variable "nginx_encrypted_disk_size" {
  description = "The size of the secondary encrypted disk - EBS"
  default = "10"
}

variable "nginx_encrypted_disk_device_name" {
  description = "The name of the device of secondary encrypted disk"
  default = "/dev/sda1"
}

variable "volumes_type" {
  description = "The type of all the disk instances in my project"
  default = "gp2"
}

variable "purpose_tag" {
  default = "Whiskey"
  type    = string
}

variable "owner_tag" {
  description = "The owner tag will be applied to every resource in the project through the 'default variables' feature"
  default = "Itzick"
  type    = string
}

variable "route_tables_names" {
  type    = list(string)
  default = ["public", "private-a", "private-b"]
}

variable "ami" {
    description = "default AMI for my project"
    type = string
    default = "ami-033b95fb8079dc481"
  
}