terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = "your token"
}

resource "github_repository" "example" {
  name        = "example"
  description = "Created using terraform"

  visibility = "public"

}