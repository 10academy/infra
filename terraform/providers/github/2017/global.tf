#--------------------------------------------------------------
# Github provisioner
#--------------------------------------------------------------

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "github_token" {}
variable "github_organization" {}

variable "name" {}
variable "region" {}
variable "tf_bucket" {}
variable "tf_state_file" {}

terraform {
  required_version = ">= 0.9.0"
  backend "s3" {
    bucket  = "10academy-terraform-infrastructure"
    key     = "github/2017/terraform.tfstate"
    region  = "eu-west-1"
    profile = "10academy"
  }
}

provider "github" {
  token        = "${var.github_token}"
  organization = "${var.github_organization}"
}

module "team_2017" {
  source  = "../../../modules/github/util/team"

  team    = "${var.name}-2017"
  members = "mannyacquah"
}
