provider "aws" {
  region = "ap-south-1"
}

variable "record_set" {
  default = "13.233.157.199"
}

/* resource "aws_route53_zone" "main" {
  name = "rsk.com"
}

resource "aws_route53_zone" "dev" {
  name = "dev.sai.com"

  tags = {
    Environment = "dev"
  }
}

resource "aws_route53_record" "www-dev" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "http"
  type    = "CNAME"
  ttl     = "30"

  weighted_routing_policy {
    weight = 30
  }
  set_identifier = "dev"
  records = ["dev.example.com"]
}

resource "aws_route53_record" "www-live" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "http"
  type    = "CNAME"
  ttl     = "30"

  weighted_routing_policy {
    weight = 70
  }
  set_identifier = "live"
  records = ["live.example.com"]
}

resource "aws_route53_record" "sample" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.rsk.com"
  type    = "A"
  ttl     = "300"
  records = ["13.233.157.199"]
} */

/* resource "aws_route53_zone" "example" {
  name = "sai.example1.com"
}

resource "aws_route53_record" "example" {
  allow_overwrite = true
  name            = "sai.example1.com"
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.example.zone_id

  records = [
    aws_route53_zone.example.name_servers[0],
    aws_route53_zone.example.name_servers[1],
    aws_route53_zone.example.name_servers[2],
    aws_route53_zone.example.name_servers[3],
  ]
} */

resource "aws_route53_health_check" "example" {
  failure_threshold = "5"
  fqdn              = "example.com"
  port              = 443
  request_interval  = "30"
  resource_path     = "/"
  search_string     = "example"
  type              = "HTTPS_STR_MATCH"
}


