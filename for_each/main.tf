provider "aws" {
  region     = "ap-south-1"
}

resource "aws_iam_user" "iam" {
  for_each = toset( ["user-01","user-02", "user-03"] )
  name     = each.value
}

resource "aws_instance" "myec2" {
  ami = "ami-0f9c44e98edf38a2b"
  for_each  = {
      key1 = "t2.micro"
      key2 = "t2.medium"
   }
  instance_type    = each.value
  key_name         = each.key
  tags =  {
   Name = each.value
    }
}