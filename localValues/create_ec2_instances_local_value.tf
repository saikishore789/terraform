provider "aws" {
  version    = "~> 3.0"
  region     = "ap-south-1"
}

locals {
  common_tags = {
    dev_instance      = "micro"
    stagging_instance = "nano"
  }
}

resource "aws_instance" "dev" {
  ami           = "ami-08e0ca9924195beba"
  instance_type = "t2.micro"
  tags          = local.common_tags
}

resource "aws_instance" "stagging" {
  ami           = "ami-08e0ca9924195beba"
  instance_type = "t2.nano"
  tags          = local.common_tags
}
