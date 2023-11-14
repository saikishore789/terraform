variable "destination_vpc_id" {
  type = string
}

variable "peer_role_arn" {
  type = string
}

provider "aws" {
  region = "us-east-1"
  alias = "peer"
  assume_role {
    role_arn = var.peer_role_arn
  }
}

data "aws_caller_identity" "peer" {
  provider = aws.peer
}

resource "aws_vpc_peering_connection" "peer" {
  vpc_id = module.vpc.vpc_id
  peer_vpc_id = var.destination_vpc_id
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_region = "us-east-1"
  auto_accept = true
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept = true
}