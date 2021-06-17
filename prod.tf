variable "whitelist" {
  type = list(string)
}
variable "web_image_id" {
  type = string
}
variable "web_instance_type" {
  type = string
}
variable "web_desired_capacity" {
  type = number
}
variable "web_max_size" {
  type = number
}
variable "web_min_size" {
  type = number
}


provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "tf-course-cb-06-14-2021"
  acl    = "private"
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az_a" {
  availability_zone = "us-west-2a"

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_default_subnet" "default_az_b" {
  availability_zone = "us-west-2b"

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_security_group" "prod_web" {
  name        = "prod_web"
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress = [ {
    cidr_blocks      = var.whitelist
    description      = "value"
    from_port        = 80
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 80
    },
    {
    cidr_blocks      = var.whitelist
    description      = "value"
    from_port        = 443
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 443
    }
  ]

  egress = [ {
    cidr_blocks      = var.whitelist
    description      = "value"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
    } 
  ]

  tags = {
    "Terraform" : "true"
  }

}

module "web_app" {
  source = "./modules/web_app"
  
  web_image_id         = var.web_image_id
  web_instance_type    = var.web_instance_type
  web_desired_capacity = var. web_desired_capacity
  web_max_size         = var.web_max_size
  web_min_size         = var.web_min_size
  subnets              = [aws_default_subnet.default_az_a.id, aws_default_subnet.default_az_b.id]
  security_groups      = [aws_security_group.prod_web]
  web_app              = "prod"
}