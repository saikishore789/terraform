provider "aws" {
  region = "ap-south-1"
}
# This is a single-line comment.
resource "aws_instance" "base" {
  ami                    = "ami-08e0ca9924195beba"
  instance_type          = "t2.micro"
  count                  = 2
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
    Name = "jmsth21_9pm${count.index}"
  }
}

resource "aws_key_pair" "keypair" {
  key_name   = "sai"
  public_key = file("/home/ec2-user/terraform/ec2-project/sai.pub")

}

resource "aws_eip" "myeip" {
  count    = length(aws_instance.base)
  vpc      = true
  instance = "${element(aws_instance.base.*.id, count.index)}"
  tags = {
    Name = "eip-${count.index + 1}"
  }
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "allow_ports" {
  name        = "alb"
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

data "aws_subnet_ids" "subnet" {
  vpc_id = "${aws_default_vpc.default.id}"

}

resource "aws_lb_target_group" "my-target-group" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "my-test-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "${aws_default_vpc.default.id}"

}

resource "aws_lb" "my-aws-alb" {
  name            = "test-lb"
  internal        = false
  security_groups = ["${aws_security_group.allow_ports.id}"]
  subnets         = data.aws_subnet_ids.subnet.ids

  tags = {
    Name = "jmsth-test-alb"
  }
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

resource "aws_lb_listener" "test-alb-listner" {
  load_balancer_arn = aws_lb.my-aws-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
  }
}

resource "aws_lb_target_group_attachment" "test" {
  count            = length(aws_instance.base)
  target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
  target_id        = aws_instance.base[count.index].id
}


