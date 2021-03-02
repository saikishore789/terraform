provider "aws" {
  access_key = "AKIA4YSPNRPDSRSQLKX5"
  secret_key = "+Zoh0u3JoNnDG7VC7KtVA0SrHhfVQNBG7kbEIZWY"
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "tfstate.file.bucket"
    key    = "rskr-sample.tfstate"
    region = "ap-south-1"
    access_key = "AKIA4YSPNRPDSRSQLKX5"
    secret_key = "+Zoh0u3JoNnDG7VC7KtVA0SrHhfVQNBG7kbEIZWY"
    dynamodb_table= "s3-tfstatefile-lock"
  }
}

module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "my-cluster"
  instance_count         = 1

  ami                    = "ami-08e0ca9924195beba"
  instance_type          = "t2.micro"
  key_name               = "feb-mum"
  monitoring             = true
  vpc_security_group_ids = ["sg-007cc4f48b583cc0f"]
  subnet_id              = "subnet-5a5d4732"

}
