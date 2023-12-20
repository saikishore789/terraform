terraform {
  backend "s3" {
    key            = "vpc/terraform.tfstate"
    bucket         = "globo-91437"
    region         = "ap-south-1"
    dynamodb_table = "globo-tfstatelock-91437"
  }
}