#--------------------------------------------------------------
# This module creates all resources necessary for a app
#--------------------------------------------------------------

variable "name" {}

variable "region" {}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "public_subnet_ids" {}

variable "key_name" {}
variable "instance_type" {}
variable "instance_port" {}
variable "user_data" {}

variable "default_tags" {
  type = "map"
}

resource "aws_security_group" "bootstrap" {
  name        = "sg_bootstrap_${var.name}"
  vpc_id      = "${var.vpc_id}"
  description = "Boostrap security group"

  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = "${var.instance_port}"
    to_port     = "${var.instance_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags        = "${merge(var.default_tags, map("Name", "sg-bootstrap"))}"
}

module "ami" {
  source        = "github.com/terraform-community-modules/tf_aws_ubuntu_ami/ebs"
  instance_type = "${var.instance_type}"
  region        = "${var.region}"
  distribution  = "trusty"
}

resource "aws_instance" "bootstrap" {
  ami                         = "${module.ami.ami_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(split(",", var.public_subnet_ids), count.index)}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.bootstrap.id}"]
  user_data                   = "${var.user_data}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  tags                        = "${merge(var.default_tags, map("Name", "ins-${var.name}"))}"
}

output "user" {
  value = "ubuntu"
}
output "private_ip" {
  value = "${aws_instance.bootstrap.private_ip}"
}
output "public_ip" {
  value = "${aws_instance.bootstrap.public_ip}"
}
