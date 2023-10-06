provider "aws" {
version = "~> 3.0"
region = "ap-south-1"
access_key = "AKIAW6XWCYYATHLOKDSH"
secret_key = "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"
}
variable "environment"{
    type = bool
    default = false
}

resource "aws_instance" "dev" {
ami = "ami-0cda377a1b884a1bc"
instance_type = "t2.micro"
count = var.environment == true ? 1 : 0
}

resource "aws_instance" "stagging" {
ami = "ami-0cda377a1b884a1bc"
instance_type = "t2.nano"
count = var.environment == false ? 1 : 0
}
