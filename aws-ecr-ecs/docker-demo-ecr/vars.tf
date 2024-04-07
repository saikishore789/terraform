variable "AWS_REGION" {
  default = "ap-south-1"
}

variable "key_pair" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJtTpknS0ViXWJtPkmw3Ew/DrgQFbTyg+4bj1hkg6NFeLcFQNin8inSfmi7cL7GMdHRzskwKoYFOLEw224667FC1SVPyu5blybvo/PS3UviKgKxjeLiPlLa9OT1IFYu4ggcMfW3Q7irn31SF/xqZMh0xwg4N0UhlWwTV1MzPFmM6Fugzi5z2plRZmhS/AcF1ktWEYzcBiMLpSjIlSLhH8+LWDeDWW2/WxOVK3DaaML/5GQM91aLIQzJ20P9Pady13cgpAEXfZ0lOfxKJnfcwiN1/Vqlz/yNW8gBdN/bm+xOQkxDbJxw8YU0tXpk8j1C6QWnGsdtpCeos4cL9Tm+sMfemTN/W0kOvXzl+NkjHQPx0d2vZNjXcCzpFVfvUwaLivwMP4XHj/YDbB/tv/2306NIxZZHHD9YOKg1m6i+Oq0JkE9miLuDmsuPx4ZHLVhDIsSX1Zf97VqyrUO4xnQzgg6M+jEJU7Z0Idjkkj90KwPFDGpaPuztVOVA16v7alpAsU= codespace@codespaces-de4bff"

}

variable "ECS_INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "ECS_AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-1924770e"
    us-west-2 = "ami-56ed4936"
    ap-south-1 = "ami-09298640a92b2d12c"
  }
}