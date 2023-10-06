provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "sample" {
  bucket = "bucket-sample-rsk1"
}

resource "aws_s3_bucket_ownership_controls" "sample" {
  bucket = aws_s3_bucket.sample.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "sample" {
    bucket = aws_s3_bucket.sample.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "sample" {
  bucket = aws_s3_bucket.sample.id
  depends_on = [ 
    aws_s3_bucket_ownership_controls.sample,
    aws_s3_bucket_public_access_block.sample,
   ]
   acl = "public-read"
} 

locals {
  s3_origin_id = "myS3Origin"
}

/*resource "aws_s3_object" "name" {
  bucket = aws_s3_bucket.sample.bucket
  key = "index.html"
  source = "../index.html"
  etag = filemd5("../index.html")
}

resource "aws_s3_bucket_acl" "sample" {
  bucket = aws_s3_bucket.sample.bucket
  acl = "public"
}*/

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.sample.bucket_regional_domain_name

    origin_id = local.s3_origin_id
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  /*logging_config {
    include_cookies = false
    bucket          = "mylogs.rsk.s3.amazonaws.com"
    prefix          = "myprefix"
  }*/
  
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
 
  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "allow-all"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  
  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "IND"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
