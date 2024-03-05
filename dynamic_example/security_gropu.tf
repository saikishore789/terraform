terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


variable "myports" {
  type    = list(number)
  default = [443, 8080, 8181]
}

resource "aws_security_group" "allow_tls" {
  name = "allow_tls"

  dynamic "ingress" {
    for_each = var.myports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["116.50.30.50/32"]
    }
  }

  tags = {
    Name = "allow tls"
  }
}


