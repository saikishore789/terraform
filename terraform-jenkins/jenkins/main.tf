variable "ami_id" {}
variable "instance_type" {}
variable "tag_name" {}
variable "public_key" {}
variable "subnet_id" {}
variable "sg_for_jenkins" {}
variable "enable_public_ip_address" {}
variable "user_data_install_jenkins" {}



output "jenkins_ec2_instance_ip" {
  value = aws_instance.jenkins_ec2_instance_ip.id
}

output "dev_proj_1_ec2_instance_public_ip" {
  value = aws_instance.jenkins_ec2_instance_ip.public_ip
}

resource "aws_instance" "jenkins_ec2_instance_ip" {
  ami = var.ami_id
  instance_type = "t2.medium"
  tags = {
    Name = var.tag_name
  }
  key_name = "terraform"
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.sg_for_jenkins
  associate_public_ip_address = var.enable_public_ip_address

  user_data = var.user_data_install_jenkins

  metadata_options {
    http_endpoint = "enabled"  
    http_tokens   = "required" 
  }

}

resource "aws_key_pair" "jenkins_ec2_instance_public_key" {
  key_name = "terraform"
  public_key = var.public_key
}