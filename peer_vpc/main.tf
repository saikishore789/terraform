variable "region" {
  type = string
  default = "us-east-1"
}

variable "vpc_cidr_range" {
  type = string
  default = "10.10.0.0/16"
}

variable "public_subnets" {
  type = list(string)
  default = [ "10.10.0.0/24", "10.10.1.0/24" ]
}

variable "private_subnets" {
  type = list(string)
  default = [ "10.0.100.0/24", "10.0.101.0/24" ]
}

variable "intra_subnets" {
  type = list(string)
  default = [ "10.0.200.0/24", "10.0.201.0/24" ]
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "azs" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  
  name = "sec-vpc"
  cidr = var.vpc_cidr_range

  azs = slice(data.aws_availability_zones.azs.names, 0, 2)
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  intra_subnets = var.intra_subnets

  tags = {
    Environment = "sec"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}