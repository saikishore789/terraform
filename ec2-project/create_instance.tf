provider "aws" {
  version = "~> 3.0"


  region = "ap-south-1"
}

resource "aws_instance" "base" {
  ami                    = "ami-08e0ca9924195beba"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.keypair.key_name}"
  vpc_security_group_ids = [aws_security_group.allow_ports.id]
  user_data              = <<-EOF
#!/bin/bash
yum install httpd -y
echo "hey i am $(hostname -f)" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF
  tags = {
    Name = "jmsth21"
  }
}


resource "aws_key_pair" "keypair" {
  key_name   = "sai"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDvqHoFP+vjUfxpa887Lj7QdJytItkIuUV/sZW2P2KQ+t5Jz4ZIkGfEQAex2ts64gUByOs1J/JhK/prU/IoDUCTwmo71+TsmOZoVeYRfey8ojst6706RazupjSmVbq8nmkPx8aB2+VNhS4xIOHC7VKv7cw2dbavTcugB45HKkq/0odQ6//UJrJdyBzjNCDLoetddVZwPUuLHrZ2C8LA19xTNxIMs1ixjDNwcUZQ5ZYELiipY36LCsVT6kNQs+cXl0evvHz6acNTkUZ+6ICUPf5VwtxcDxbwXkQ69cmdPW54rd/ReXrSpPUKZMhBGAU03ODv0RrZy4uNI757fkQj51wv ec2-user@ip-172-31-42-95.ap-south-1.compute.internal"
}

resource "aws_eip" "myeip" {
  vpc      = true
  instance = "${aws_instance.base.id}"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "default vpc"
  }
}

resource "aws_security_group" "allow_ports" {
  name        = "allow_ports1"
  description = "Allow inbound traffic"
  vpc_id      = "${aws_default_vpc.default.id}"
  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "tomcat port from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ports"
  }
}

