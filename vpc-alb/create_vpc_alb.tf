provider "aws" {
  version = "~> 3.0"


  region = "ap-south-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "gw" {
   vpc_id= aws_vpc.main.id
tags =  {
    Name = "main"
  }
}

variable "subnet_cidr" {
  type= "list"
default= ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
  type= "list"
default= ["ap-south-1a", "ap-south-1b"]
}

resource "aws_subnet" "subnet" {
  count = "${length(var.subnet_cidr)}"
  vpc_id     = aws_vpc.main.id
  cidr_block= "${element(var.subnet_cidr,count.index)}"
  availability_zone = "${element(var.azs,count.index)}"
tags =  {
    Name = "Subnet-${count.index+1}"
  }
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.main.id
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
tags =  {
    Name = "publicRouteTable"
  }
}

resource "aws_route_table_association" "a" {
  count = "${length(var.subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.subnet.*.id,count.index)}"
  route_table_id = aws_route_table.r.id
}
resource "aws_security_group" "webservers" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
 vpc_id      = "${aws_vpc.main.id}"

ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
variable "number_instances" {
default= "2"
}
resource "aws_instance" "servers" {
  count= var.number_instances
  ami = "ami-08e0ca9924195beba"
  instance_type = "t2.micro"
  key_name= "feb-mum"
  subnet_id = "${element(aws_subnet.subnet.*.id,count.index)}"
  security_groups= ["${aws_security_group.webservers.id}"]

 user_data= <<-EOF
             #!/bin/bash
              yum install httpd -y
              echo "hey i am $(hostname -f)" > /var/www/html/index.html
              service httpd start
              chkconfig httpd on
              EOF
	tags =  {
	  Name = "Server-${count.index}"
	}
}
resource "aws_elb" "test" {
  name               = "test-lb-tf"
  availability_zones = "${var.azs}"
  security_groups    = [aws_security_group.webservers.id]
  subnets            = aws_subnet.subnet.*.id
listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }
instances                   = "${aws_instance.servers.*.id}"
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "terraform-elb"
  }
}
output "elb-dns-name" {
  value = "${aws_elb.test.dns_name}"
}
