terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.74.3"
    }
  }
  cloud {
    hostname = "app.terraform.io"
    organization = "itzick-ops-school"
    workspaces {
      name = "Whiskey-Itzick"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}