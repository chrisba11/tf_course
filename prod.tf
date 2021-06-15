provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "tf-course-cb-06-14-2021"
  acl    = "private"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod_web" {
  name        = "prod_web"
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "value"
    from_port = 80
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "tcp"
    security_groups = []
    self = false
    to_port = 80
    },
    {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "value"
    from_port = 443
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "tcp"
    security_groups = []
    self = false
    to_port = 443
    }
  ]

  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "value"
    from_port = 0
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "-1"
    security_groups = []
    self = false
    to_port = 0
  } ]

  tags = {
    "Terraform" : "true"
  }

}
