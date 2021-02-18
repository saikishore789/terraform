provider "aws" {
  version    = "~> 3.0"
  access_key = "AKIAW6XWCYYARMH2WFB2"
  secret_key = "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"
  region     = "ap-south-1"
}

data "aws_ami" "my_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
resource "aws_instance" "web" {
  ami           = data.aws_ami.my_ami.id
  instance_type = "t2.micro"
}
