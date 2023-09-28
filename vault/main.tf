provider "aws" {
  region = "ap-south-1"
}

provider "vault" {
  address = "http://3.110.45.194:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "3fcf86a2-3992-2938-4ae4-f975c5616103"
      secret_id = "b62ebd19-60ed-5fd0-8fe1-722bf1029910"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "secret"
}

resource "aws_s3_bucket" "example" {
  bucket = data.vault_kv_secret_v2.example.data["username"]

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
