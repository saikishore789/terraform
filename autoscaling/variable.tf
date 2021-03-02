variable "no-of-instances" {
    default = 1
 }
variable "region" {
  description = "AWS region for hosting our your network"
  default = "ap-south-1"
}
variable "public_key_path" {
  description = "mykey file path"
  default = "/home/ec2-user/terraform/ec2-project/sai.pub"
}
variable "key_name" {
  description = "Key name for SSHing into EC2"
  default = "sai"
}
variable "amiid" {
  description = "Base ami to launch the instances"
  default = "ami-08e0ca9924195beba"
}
