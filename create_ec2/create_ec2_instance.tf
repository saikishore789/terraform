provider "aws" {
  region = var.region
}
resource "aws_instance" "web" {
  count = 2
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.keyName
}
