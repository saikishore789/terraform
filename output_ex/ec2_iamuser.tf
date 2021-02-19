provider "aws" {
  version = "~> 3.0"
  access_key = "AKIAQKEDAIJINVZZJUUD"
  secret_key = "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"
  region = "ap-south-1"
}

resource "aws_iam_user" "lb" {
  name= "iamuser.${count.index}"
  count = 3
  path = "/system/"
}

output "iam_arn" {
  value= aws_iam_user.lb[*].arn
}

output "iam_names" {
  value= aws_iam_user.lb[*].name
}

