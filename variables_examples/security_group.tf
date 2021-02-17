provider "aws" {
version = "~> 3.0"
region = "ap-south-1"
access_key = "AKIAW6XWCYYATIPWLWH3"
secret_key = "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"
}

resource "aws_security_group" "allow_tls" {
name = "allow_tls"
ingress {
description = "TLS from VPC"
from_port = 443
to_port = 443
protocol = "tcp"
cidr_blocks = [var.my_ip]
}

ingress {
description = "http port"
from_port = 80
to_port = 80
protocol = "tcp"

cidr_blocks = [var.my_ip]
}

ingress {
description = "jenkins port"
from_port = 8080
to_port = 8080
protocol = "tcp"
cidr_blocks =  [var.my_ip]
}

egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

tags = {
Name = "allow_tls"
}
}


