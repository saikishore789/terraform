provider "aws" {
  version = "~> 3.0"
  access_key = "AKIA4YSPNRPDSRSQLKX5"
  secret_key = "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"
  region = "ap-south-1"
}

resource "aws_instance" "base" {
  ami = "ami-08e0ca9924195beba"
  instance_type = lookup(var.instance_type,terraform.workspace)
}

variable "instance_type" {
  type= "map"
  default= {
    default= "t2.nano"
    dev= "t2.micro"
    prod= "t2.medium"
}
}

