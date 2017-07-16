#--------------------------------------------------------------
# Cloudflare privisioner
#--------------------------------------------------------------

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}

variable "cloudflare_email" {}
variable "cloudflare_token" {}

variable "domain" {}

variable "tf_bucket" {}
variable "tf_state_file" {}
variable "tf_state_file_aws_2017" {}

terraform {
  required_version = ">= 0.9.0"
  backend "s3" {
    bucket  = "10academy-terraform-infrastructure"
    key     = "cloudflare/2017/terraform.tfstate"
    region  = "eu-west-1"
    profile = "10academy"
  }
}

data "terraform_remote_state" "aws_2017" {
  backend = "s3"
  config {
    bucket  = "${var.tf_bucket}"
    key     = "${var.tf_state_file_aws_2017}"
    region  = "${var.region}"
    profile = "10academy"
  }
}

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

resource "cloudflare_record" "demo" {
  domain = "${var.domain}"
  name   = "demo.${var.domain}"
  type   = "A"
  ttl    = "300"
  value  = "${data.terraform_remote_state.aws_2017.demo_public_ip}"
}
