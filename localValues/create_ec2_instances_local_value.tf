provider "aws" {
  version    = "~> 3.0"
  region     = "ap-south-1"
  access_key = "AKIAW6XWCYYATHLOKDSH"
  secret_key = "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"
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
