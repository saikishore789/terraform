resource "aws_instance" "base" {
  ami = "ami-010f8b02680f80998"
  instance_type = var.ec2_instance_type
  
}
