provider "aws" {
  region = "ap-south-1"
}

# Additional provider configuration for west coast region of another account; resources can
# reference this as `aws.west`.
provider "aws" {
  alias  = "account02"
  region = "us-east-1"
  profile = "account02"
}

resource "aws_instance" "base" {
  ami           = "ami-08e0ca9924195beba"
  instance_type = "t2.micro"
}

resource "aws_instance" "base-1" {
  provider      = aws.account02
  ami           = "ami-047a51fa27710816e"
  instance_type = "t2.micro"
}
