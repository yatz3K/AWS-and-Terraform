terraform {
  backend "s3" {
    bucket = "itzick-opsschool-whiskey"
    key = "whiskey/terraform.tfstate"
    profile = "default"
    region = "us-east-1"
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region

  default_tags {
    tags = {
      Owner = var.owner_tag
      Purpose = var.purpose_tag
    }
  }
}