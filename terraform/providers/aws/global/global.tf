#--------------------------------------------------------------
# Global
#--------------------------------------------------------------

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_profile" {}

variable "name" {}
variable "region" {}
variable "iam_admins" {}
variable "iam_billing" {}
variable "tf_bucket" {}
variable "tf_state_file" {}
variable "domain" {}

terraform {
  required_version = ">= 0.9.0"
  backend "s3" {
    bucket  = "10academy-terraform-infrastructure"
    key     = "aws/global/terraform.tfstate"
    profile = "10academy"
    region  = "eu-west-1"
  }
}

provider "aws" {
  region  = "${var.region}"
  profile = "${var.aws_profile}"
}

module "iam_admin" {
  source = "../../../modules/aws/util/iam"

  name   = "${var.name}-admin"
  users  = "${var.iam_admins}"
  policy = <<EOF
{
  "Version"  : "2012-10-17",
  "Statement": [
    {
      "Effect"  : "Allow",
      "Action"  : "*",
      "Resource": "*"
    }
  ]
}
EOF
}

module "iam_billing" {
  source = "../../../modules/aws/util/iam"

  name   = "${var.name}-billing"
  users  = "${var.iam_billing}"
  policy = <<EOF
{
  "Version"  : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "aws-portal:ViewUsage",
          "aws-portal:ViewBilling"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "assets" {
  bucket = "${var.name}-assets"
  acl    = "public-read"
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
         {
           "Sid": "AllowPublicRead",
           "Effect": "Allow",
           "Principal": {
             "AWS": "*"
           },
           "Action": "s3:GetObject",
           "Resource": "arn:aws:s3:::${var.name}-assets/*"
         }
    ]
}
EOF

  tags {
    Name = "${var.name}-assets"
  }
}

resource "aws_route53_zone" "zone" {
  name = "${var.domain}"
}

output "config" {
  value = <<CONFIG

Admin IAM:
  Admin Users: ${join("\n", formatlist("%s", split(",", module.iam_admin.users)))}

  Access IDs: ${join("\n", formatlist("%s", split(",", module.iam_admin.access_ids)))}

  Secret Keys: ${join("\n", formatlist("%s", split(",", module.iam_admin.secret_keys)))}

Billing IAM:
  Billing Users: ${join("\n", formatlist("%s", split(",", module.iam_billing.users)))}

  Access IDs: ${join("\n", formatlist("%s", split(",", module.iam_billing.access_ids)))}

  Secret Keys: ${join("\n", formatlist("%s", split(",", module.iam_billing.secret_keys)))}

CONFIG
}

output "iam_admin_users" {
  value = "${module.iam_admin.users}"
}

output "iam_admin_access_ids" {
  value = "${module.iam_admin.access_ids}"
}

output "iam_admin_secret_keys" {
  value = "${module.iam_admin.secret_keys}"
}

output "zone_id" {
  value = "${aws_route53_zone.zone.zone_id}"
}

output "domain" {
  value = "${aws_route53_zone.zone.name}"
}
