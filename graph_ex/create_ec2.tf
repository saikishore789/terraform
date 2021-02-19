provider "aws" {
  version = "~> 3.0"
  access_key = "AKIAQKEDAIJINVZZJUUD"
  secret_key = "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"
  region = "ap-south-1"
}

resource "aws_instance" "base" {
  ami = "ami-08e0ca9924195beba"
  instance_type = "t2.nano"
}

resource "aws_eip" "lb" {
  instance= aws_instance.base.id
  vpc = true
}

resource "aws_security_group" "allowtls" {
  name        = "allow_tls"
  ingress{
    description= "tls from vpc"
    from_port= 443
    to_port= 443
     protocol    = "tcp"
    cidr_blocks = ["${aws_eip.lb.private_ip}/32"]
  }
}


