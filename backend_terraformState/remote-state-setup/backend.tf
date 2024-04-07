terraform {
  backend "s3" {
    bucket = "globo-68138"
    key = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "globo-tfstatelock-68138"
  }
}
resource "aws_instance" "ec2" {
  ami = "ami-00952f27cf14db9cd"
  instance_type = "t2.large"

}