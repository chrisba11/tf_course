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
    cidr_blocks      = [ "0.0.0.0/0" ]
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
    cidr_blocks      = [ "0.0.0.0/0" ]
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
    cidr_blocks      = [ "0.0.0.0/0" ]
    description      = "value"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  } ]

  tags = {
    "Terraform" : "true"
  }

}

resource "aws_instance" "prod_web" {
  count = 2

  ami           = "ami-0235290bfade69c7c"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]

  tags = {
    "Terraform" : "true"
  }

}

resource "aws_eip_association" "prod_web" {
  instance_id   = aws_instance.prod_web.0.id  #can also use [0] instead of .0
  allocation_id = aws_eip.prod_web.id
}

resource "aws_eip" "prod_web" {
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_elb" "prod_web" {
  name            = "prod-web"  #cannot use underscores for internal name
  instances       = aws_instance.prod_web.*.id
  subnets         = [aws_default_subnet.default_az_a.id, aws_default_subnet.default_az_b.id]
  security_groups = [aws_security_group.prod_web.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  
  tags = {
    "Terraform" : "true"
  }
}
