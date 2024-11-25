terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC 모듈 호출
module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  public_count = var.public_subnet_count
  private_count = var.private_subnet_count
  availability_zones = var.availability_zones
}

# EC2 모듈 호출
module "ec2" {
  source               = "./modules/ec2"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  public_subnet_id     = element(module.vpc.public_subnet_ids, 0)
  security_group_id    = module.vpc.ec2_security_group_id
}
