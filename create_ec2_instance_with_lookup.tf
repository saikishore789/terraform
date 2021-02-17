provider "aws" {
  version = "~> 3.0"
  access_key = "AKIAW6XWCYYATHLOKDSH"
  secret_key = "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"
  region = "ap-south-1"
}

variable "ami" {
type = map
default = {
"us-east-1" = "ami-0947d2ba12ee1ff75"
"ap-south-1" = "ami-08e0ca9924195beba"
}
}

variable "region"{
default = "ap-south-1"
}

variable "tags" {
type = list
default = ["firstec2","secondec2"]
}

resource "aws_key_pair" "my_key" {
key_name = "t-key"
public_key = file("${path.module}/terraform.pub")
}

resource "aws_instance" "dev"{
ami= lookup(var.ami,var.region)
key_name= aws_key_pair.my_key.key_name
instance_type = "t2.micro"
count= 2

tags= {
Name= element(var.tags,count.index)
}
}

locals {
time = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
}
output "timestamp" {
value = local.time
}
