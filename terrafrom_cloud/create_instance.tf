terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "SynergyGlobalSystems"

    workspaces {
      name = "my-app-prod"
    }
  }
} 

provider "aws" {
  version = "~> 3.0"


  region = "ap-south-1"
}

resource "aws_instance" "base" {
  ami = "ami-08e0ca9924195beba"
  instance_type = "t2.micro"
}

