provider "aws" {
  version    = "~> 3.0"
  region     = var.region
  access_key = var.accesskey
  secret_key = var.secretkey
}
resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.keyName
}
