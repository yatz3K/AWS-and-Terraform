variable "db_instance_type" {
  description = "type of db instances"
  type = string
}

variable "key_name" {
  default     = "linux-vm"
  description = "The key name of the Key Pair to use for the instance"
  type        = string
}

variable "DB_instances_count" {
    type = number
}

variable "volumes_type" {
  description = "The type of all the disk instances in my project"
  type = string
}

variable "ami" {
    description = "default AMI for my project"
    type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets_id" {
   type = list(string)
}