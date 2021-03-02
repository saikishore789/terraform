provider "aws" {
  version = "~> 3.0"


  region = "ap-south-1"
}
#resource "aws_kms_key" "mykey" {
#  description             = "This key is used to encrypt bucket objects"
 # deletion_window_in_days = 10
#}
resource "aws_s3_bucket" "bucket" {
  bucket = "rskr-bucket"
  acl    = "public-read"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
  versioning {
    enabled = true
  }
#  server_side_encryption_configuration {
#    rule {
#      apply_server_side_encryption_by_default {
#        kms_master_key_id = aws_kms_key.mykey.arn
  #      sse_algorithm     = "aws:kms"
 #     }
#    }
#  }
}
resource "aws_s3_bucket_object" "object" {
  bucket   = "${aws_s3_bucket.bucket.id}"
  for_each = fileset(path.module, "**/*.html")
  #content_type= "text/html"
  key      = each.value
  source   = "${path.module}/${each.value}"
}
output "website-endpoint" {
  value = aws_s3_bucket.bucket.website_endpoint
}

resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.default.json
}
data "aws_iam_policy_document" "default" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

