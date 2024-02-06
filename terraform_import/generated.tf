# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "4604237838b2392205c3a7f9db834463b1cd65471ce3cc4c4ca01bd991a3dfbc"
resource "docker_container" "web" {
  env = []
  image = docker_image.nginx.image_id
  name  = "hashicorp-learn"
  ports {
    external = 8081
    internal = 80
    ip       = "0.0.0.0"
    protocol = "tcp"
  }
}
