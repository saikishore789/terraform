provider "aws" {
  version = "~> 3.0"
  access_key = "AKIAW6XWCYYATHLOKDSH"
  secret_key = "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"
  region = "ap-south-1"
}

resource "aws_instance" "base" {
  ami = "ami-08e0ca9924195beba"
  instance_type = var.list[1]
  key_name   = "rskr"

}
