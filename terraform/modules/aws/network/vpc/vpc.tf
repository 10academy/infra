#--------------------------------------------------------------
# This module creates all resources necessary for a VPC
#--------------------------------------------------------------

variable "name" {}
variable "default_tags" {
  type = "map"
}
variable "cidr" {}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  lifecycle {
    create_before_destroy = true
  }

  tags                 = "${merge(var.default_tags, map("Name", "vpc-${var.name}"))}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
}
