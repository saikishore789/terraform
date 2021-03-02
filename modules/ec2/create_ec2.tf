resource "aws_instance" "base" {
  ami = "ami-08e0ca9924195beba"
  instance_type = var.ec2_instance_type
}
