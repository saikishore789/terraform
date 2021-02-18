provider "aws" {
  version    = "~> 3.0"
  access_key = "AKIAW6XWCYYARMH2WFB2"
  secret_key = "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"
  region     = "ap-south-1"
}

variable "myports" {
  type    = list(number)
  default = [443, 8080, 8181]
}

resource "aws_security_group" "allow_tls" {
  name = "allow_tls"

  dynamic "ingress" {
    for_each = var.myports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["116.50.30.50/32"]
    }
  }

  tags = {
    Name = "allow tls"
  }
}


