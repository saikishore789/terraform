provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "myec2" {
#    ami = "ami-0f34c5ae932e6f0e4"
# changing to windows ami
    ami = "ami-0f9c44e98edf38a2b"
    instance_type = "t2.micro"

    tags = {
        Name = "HelloEarth"
    }

    lifecycle {
#      create_before_destroy = true
#      prevent_destroy = true
      ignore_changes = [tags]
    }
}