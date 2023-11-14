variable "region_east" {
  type = string
  default = "us-east-1"
}

variable "region_west" {
  type = string
  default = "us-west-1"
}

variable "peering_users" {
  type = list(string)
}

provider "aws" {
  region = var.region_east
  alias = "east"
}

provider "aws" {
  region = var.region_west
  alias = "west"
}

data "aws_caller_identity" "east" {
  provider = aws.east
}

data "aws_caller_identity" "west" {
  provider = aws.west
}

resource "aws_iam_role_policy" "peering_policy" {
  name = "vpc_peering_policy"
  role = aws_iam_role.peer_role.id
  provider = aws.west
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:AcceptVpcPeeringConnection",
                "ec2:DescribeVpcPeerigConnections"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
  }
  EOF
}

resource "aws_iam_role" "peer_role" {
  name = "peer_role"
  provider = aws.west
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.east.account_id}:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
        }
    ]
  }
  EOF
}

resource "aws_iam_group" "peering" {
  name = "VPCPeering"
  provider = aws.east
}

resource "aws_iam_group_membership" "peering_members" {
  name = "VPCPeeringMembers"
  provider = aws.east

  users = var.peering_users
  group = aws_iam_group.peering.name
}

resource "aws_iam_group_policy" "peering_policy" {
  name = "peering_policy"
  group = aws_iam_group.peering.id
  provider = aws.east
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "${aws_iam_role.peer_role.arn}"
        }
    ]
  } 
  EOF
}

output "peer_role_arn" {
  value = aws_iam_role.peer_role.arn
}