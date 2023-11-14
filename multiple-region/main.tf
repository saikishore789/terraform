variable "region_east" {
  type = string
  default = "us-east-1"
}

variable "region_west" {
  type = string
  default = "us-west-1"
}

variable "vpc_cidr_range_east" {
  type = string
  default = "10.10.0.0/16"
}

variable "public_subnet_east" {
  type = list(string)
  default = [ "10.10.0.0/24", "10.10.1.0/24" ]
}

variable "database_subnet_east" {
  type = list(string)
  default = [ "10.11.8.0/24", "10.11.9.0/24" ]
}

variable "vpc_cidr_range_west" {
  type = string
  default = "10.11.0.0/16"
}

variable "public_subnet_west" {
  type = list(string)
  default = [ "10.11.0.0/24", "10.11.1.0/24" ]
}

variable "database_subnet_west" {
  type = list(string)
  default = [ "10.11.8.0/24", "10.11.9.0/24" ]
}

provider "aws" {
  region = var.region_east
  alias = "east"
}

provider "aws" {
  region = var.region_west
  alias = "west"
}

data "aws_availability_zones" "azs_east" {
  provider = aws.east
}

data "aws_availability_zones" "azs_west" {
    provider = aws.west
}

module "vpc_east" {
  source = "terraform-aws-modules/vpc/aws"

  
  name = "prod-vpc-east"
  cidr = var.vpc_cidr_range_east

  azs = slice(data.aws_availability_zones.azs_east.names, 0, 2)
  public_subnets = var.public_subnet_east

  database_subnets = var.database_subnet_east
  database_subnet_group_tags = {
    subnet_type = "database"
  }

  providers = {
    aws = aws.east
  }

  tags = {
    Environment = "prod"
    region = "east"
  }
}

module "vpc_west" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "prod-vpc-west"
  cidr = var.vpc_cidr_range_west
  azs = slice(data.aws_availability_zones.azs_west.names, 0 ,2)
  public_subnets = var.database_subnet_west

  database_subnets = var.database_subnet_west
  database_subnet_group_tags = {
    subnet_type = "database"
  }

  providers = {
    aws = aws.west
  }

  tags = {
    Environment = "prod"
    region = "west"
  }
}