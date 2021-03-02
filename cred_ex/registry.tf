provider "aws" {
  region = "ap-south-1"
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

tags= {

  Terraform= "true"
  Environment= "dev"
}
}
