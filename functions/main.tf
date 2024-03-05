provider "aws" {
  region = var.region
}

locals {
  time = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
#  base_dir = path.root
  base_dir = path.cwd
}

variable "region" {
  default = "ap-south-1"
}

variable "ami" {
  type = map
  default = {
    "us-east-1" = "ami-0323c3dd2da7fb37d"
    "us-west-2" = "ami-0d6621c01e8c2de2c"
    "ap-south-1" = "ami-0470e33cd681b2476"
  }
}

variable "tags" {
  type = list
  default = ["firstec2","secondec2"]
}

resource "aws_key_pair" "loginkey" {
  key_name = "login_key"
  public_key = file("../../../home/codespace/.ssh/id_rsa.pub")
}

resource "aws_instance" "instance" {
  ami = lookup(var.ami, var.region)
  instance_type = "t2.micro"
  key_name = aws_key_pair.loginkey.key_name
  count = 2

  tags = {
    Name = element(var.tags, count.index)
  }
}

resource "aws_s3_bucket" "example_bucket" {
#  bucket = "example-bucket${local.base_dir}"
    bucket = "example-bucket-${path.module}"
}

output "timestamp" {
  value = local.time
}