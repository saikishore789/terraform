data "terraform_remote_state" "eip" {
  backend = "s3"

  config = {
    bucket = "mypolicy-s3-2"
    key = "network/eip.tfstate"
    region = "ap-south-1"
  }
}