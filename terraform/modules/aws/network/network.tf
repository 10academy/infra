#--------------------------------------------------------------
# This module creates all networking resources
#--------------------------------------------------------------

variable "name" {}

variable "region" {}
variable "zone_id" {}
variable "azs" {}
variable "vpc_cidr" {}
variable "public_subnets" {}

variable "key_name" {}
variable "private_key" {}

variable "sub_domain" {}

variable "default_tags" {
  type = "map"
}

module "vpc" {
  source       = "./vpc"

  name         = "${var.name}"
  default_tags = "${var.default_tags}"

  cidr         = "${var.vpc_cidr}"
}

module "public_subnet" {
  source       = "./public_subnet"

  name         = "${var.name}-public"
  default_tags = "${var.default_tags}"

  vpc_id       = "${module.vpc.vpc_id}"
  cidrs        = "${var.public_subnets}"
  azs          = "${var.azs}"
}

# VPC
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_cidr" {
  value = "${module.vpc.vpc_cidr}"
}

# Subnets
output "public_subnet_ids" {
  value = "${module.public_subnet.subnet_ids}"
}
