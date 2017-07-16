#--------------------------------------------------------------
# This module creates all app resources
#--------------------------------------------------------------
variable "name" {}
variable "teams" {}

variable "env" {}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "azs" {}
variable "region" {}
variable "public_subnet_ids" {}
variable "private_key" {}
variable "key_name" {}
variable "instance_type" {}
variable "instance_port" {}

variable "user_data" {}
variable "zone_id" {}
variable "default_tags" {
  type = "map"
}

module "bootstrap" {
  source            = "./bootstrap"

  name              = "${var.name}"
  team_name         = "${var.teams}"
  default_tags      = "${var.default_tags}"

  region            = "${var.region}"
  vpc_id            = "${var.vpc_id}"
  vpc_cidr          = "${var.vpc_cidr}"
  public_subnet_ids = "${var.public_subnet_ids}"

  instance_port     = "${var.instance_port}"
  instance_type     = "${var.instance_type}"
  key_name          = "${var.key_name}"
  user_data         = "${var.user_data}"
}

output "public_ip" {
  value = "${module.bootstrap.public_ip}"
}
