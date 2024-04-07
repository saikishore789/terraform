resource "aws_ecr_repository" "test" {
  name                 = "test"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr-url" {
  value = aws_ecr_repository.test.repository_url
}