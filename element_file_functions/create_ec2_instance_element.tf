provider "aws" {
  version    = "~> 3.0"
  access_key = "AKIAW6XWCYYATHLOKDSH"
  secret_key = "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"
  region     = "ap-south-1"
}

#variable "tags" {
#type = list
#default = ["firstec2","secondec2"]
#}

resource "aws_key_pair" "my_key" {
  key_name   = "terraform-key"
  public_key = file("${path.module}/terraform.pub")
}

resource "aws_instance" "base" {
  ami           = "ami-08e0ca9924195beba"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key.key_name
  count         = 2

  tags = {
    #Name= element(var.tags,count.index)
    Name = element(["firstec2", "secondec2"], count.index)
  }
}

