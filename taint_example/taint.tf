provider "aws" {
  version = "~> 3.0"
  access_key = "AKIAW6XWCYYARMH2WFB2"
  secret_key = "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"
  region = "ap-south-1"
}

resource "aws_instance" "base" {
  ami = "ami-08e0ca9924195beba"
  instance_type = "t2.micro"
  key_name   = "rskr"

}
