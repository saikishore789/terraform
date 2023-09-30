variable "website_setting" {
  type = object({
    index_document = string
    error_document = string
  })
  default = null
}

provider "aws" {
   region = "ap-south-1"
}

resource "aws_s3_bucket" "example" {
  # ...

  dynamic "website" {
    for_each = var.website_setting[*]
    content {
      index_document = website.value.index_document
      error_document = website.value.error_document
    }
  }
}

