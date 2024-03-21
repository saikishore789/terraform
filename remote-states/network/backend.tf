terraform {
  backend "s3" {
    bucket = "mypolicy-s3-2"
    key = "network/eip.tfstate"
    region = "ap-south-1"
  }
}