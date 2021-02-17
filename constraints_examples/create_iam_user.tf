provider "aws" {
  version    = "~> 3.0"
  access_key = "AKIAW6XWCYYATIPWLWH3"
  secret_key = "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"
  region     = "ap-south-1"
}

resource "aws_iam_user" "uname" {
  name = var.username
  path = "/"

  tags = {
    tag-key = "dev-user"
  }
}
