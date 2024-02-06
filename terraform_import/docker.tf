/*import {
  id = "4604237838b2392205c3a7f9db834463b1cd65471ce3cc4c4ca01bd991a3dfbc"
  to = docker_container.web
}*/

resource "docker_image" "nginx" {
  name         = "nginx:latest"
}

