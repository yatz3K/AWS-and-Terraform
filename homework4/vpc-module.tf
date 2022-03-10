module "vpc" {
  source = "./vpc-module"
  vpc_cidr_block = "192.168.0.0/16"
  private_subnet_list = ["192.168.10.0/24", "192.168.20.0/24"]
  public_subnet_list = ["192.168.100.0/24", "192.168.200.0/24"]
  aws_availability_zones = slice(data.aws_availability_zones.available.*.names[0], 0, 2)
}