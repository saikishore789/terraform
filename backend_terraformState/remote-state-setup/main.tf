variable "region" {
  type = string
  default = "ap-south-1"
}

variable "bucket_prefix" {
  type = string
  default = "globo"
}

variable "dynamodb_table" {
  type = string
  default = "globo-tfstatelock"
}

variable "full_access_users" {
  type = list(string)
  default = [] 
}

variable "read_only_users" {
  type = list(string)
  default = []
}

provider "aws" {
  region = var.region
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

locals {
    dynamodb_table_name = "${var.dynamodb_table}-${random_integer.rand.result}"
    bucket_name = "${var.bucket_prefix}-${random_integer.rand.result}"
}

resource "aws_dynamodb_table" "terraform_statelock" {
  name           = local.dynamodb_table_name
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}

resource "aws_s3_bucket" "state_bucket" {
  bucket = local.bucket_name
  force_destroy = true

}

resource "aws_iam_group" "bucket_full_access" {
  name = "${local.bucket_name}-full-access"
}

resource "aws_iam_group" "bucket_read_only" {
  name = "${local.bucket_name}-read-access"
}

resource "aws_iam_group_membership" "full_access" {
  name = "${local.bucket_name}-full-access"
  users = var.full_access_users
  group = aws_iam_group.bucket_full_access.name
}

resource "aws_iam_group_membership" "read_access" {
  name = "${local.bucket_name}-read-access"
  users = var.read_only_users
  group = aws_iam_group.bucket_read_only.name
}

resource "aws_iam_group_policy" "full_access" {
  name = "${local.bucket_name}-full-access"
  group = aws_iam_group.bucket_full_access.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::${local.bucket_name}",
              "arn:aws:s3:::${local.bucket_name}/*"
            ]
        }, 
              {
            "Effect": "Allow",
            "Action": [
                "dynamodb:*"
            ],
            "Resource": [
                "${aws_dynamodb_table.terraform_statelock.arn}"
              ]
        }
      ]
}
EOF
}

resource "aws_iam_group_policy" "read_access" {
  name = "${local.bucket_name}-read-access"
  group = aws_iam_group.bucket_read_only.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::${local.bucket_name}",
              "arn:aws:s3:::${local.bucket_name}/*"
            ]
        }
    ]
}
EOF
}

output "s3_bucket" {
  value = aws_s3_bucket.state_bucket.bucket
}

output "dynamodb_statelock" {
  value = aws_dynamodb_table.terraform_statelock.name
}

