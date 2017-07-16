#--------------------------------------------------------------
# 2017
#--------------------------------------------------------------

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_profile" {}

variable "name" {}
variable "env" {}
variable "default_tags" {
  type = "map"
}
variable "region" {}
variable "public_subnets" {}
variable "sub_domain" {}
variable "tf_bucket" {}
variable "tf_state_file" {}
variable "tf_state_file_global" {}
variable "vpc_cidr" {}
variable "azs" {}
variable "instance_port" {}
variable "instance_type" {}

terraform {
  required_version = ">= 0.9.0"
  backend "s3" {
    bucket  = "10academy-terraform-infrastructure"
    key     = "aws/2017/terraform.tfstate"
    region  = "eu-west-1"
    profile = "10academy"
  }
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config {
    bucket  = "${var.tf_bucket}"
    key     = "${var.tf_state_file_global}"
    region  = "${var.region}"
    profile = "${var.aws_profile}"
  }
}

provider "aws" {
  region  = "${var.region}"
  profile = "${var.aws_profile}"
}

resource "aws_key_pair" "main" {
  key_name   = "kp-${var.env}-main"
  public_key = "${file("${path.cwd}/../keys/10academy.pub")}"
}

module "network" {
  source         = "../../../modules/aws/network"

  name           = "${var.name}"
  default_tags   = "${var.default_tags}"

  vpc_cidr       = "${var.vpc_cidr}"
  region         = "${var.region}"
  public_subnets = "${var.public_subnets}"
  azs            = "${var.azs}"

  key_name       = "${aws_key_pair.main.key_name}"
  private_key    = "${file("${path.cwd}/../keys/10academy.key")}"
  sub_domain     = "${var.sub_domain}"

  zone_id        = "${data.terraform_remote_state.global.zone_id}"
}

resource "aws_security_group" "bootstrap" {
  name        = "sg_bootstrap_${var.name}"
  vpc_id      = "${module.network.vpc_id}"
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

  ingress {
    protocol    = "tcp"
    from_port   = "${var.instance_port}"
    to_port     = "${var.instance_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
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

resource "aws_instance" "team1" {
  ami                         = "${module.ami.ami_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(split(",", module.network.public_subnet_ids), count.index)}"
  key_name                    = "${aws_key_pair.main.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.bootstrap.id}"]
  user_data                   = "${file("${path.cwd}/user_data.txt")}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  tags                        = "${merge(var.default_tags, map("Name", "ins-team1-${var.name}"))}"
}

resource "aws_instance" "team2" {
  ami                         = "${module.ami.ami_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(split(",", module.network.public_subnet_ids), count.index)}"
  key_name                    = "${aws_key_pair.main.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.bootstrap.id}"]
  user_data                   = "${file("${path.cwd}/user_data.txt")}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  tags                        = "${merge(var.default_tags, map("Name", "ins-team2-${var.name}"))}"
}

resource "aws_instance" "team3" {
  ami                         = "${module.ami.ami_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(split(",", module.network.public_subnet_ids), count.index)}"
  key_name                    = "${aws_key_pair.main.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.bootstrap.id}"]
  user_data                   = "${file("${path.cwd}/user_data.txt")}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  tags                        = "${merge(var.default_tags, map("Name", "ins-team3-${var.name}"))}"
}

resource "aws_instance" "team4" {
  ami                         = "${module.ami.ami_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(split(",", module.network.public_subnet_ids), count.index)}"
  key_name                    = "${aws_key_pair.main.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.bootstrap.id}"]
  user_data                   = "${file("${path.cwd}/user_data.txt")}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  tags                        = "${merge(var.default_tags, map("Name", "ins-team4-${var.name}"))}"
}

resource "aws_instance" "team5" {
  ami                         = "${module.ami.ami_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(split(",", module.network.public_subnet_ids), count.index)}"
  key_name                    = "${aws_key_pair.main.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.bootstrap.id}"]
  user_data                   = "${file("${path.cwd}/user_data.txt")}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  tags                        = "${merge(var.default_tags, map("Name", "ins-team5-${var.name}"))}"
}

resource "aws_instance" "demo" {
  ami                         = "${module.ami.ami_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(split(",", module.network.public_subnet_ids), count.index)}"
  key_name                    = "${aws_key_pair.main.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.bootstrap.id}"]
  user_data                   = "${file("${path.cwd}/user_data.txt")}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  tags                        = "${merge(var.default_tags, map("Name", "ins-demo-${var.name}"))}"
}

output "config" {
  value = <<CONFIGURATION
Bootstrap IPs:
  2017 Team 1: ${aws_instance.team1.public_ip}
  2017 Team 2: ${aws_instance.team2.public_ip}
  2017 Team 3: ${aws_instance.team3.public_ip}
  2017 Team 4: ${aws_instance.team4.public_ip}
  2017 Team 5: ${aws_instance.team5.public_ip}
  2017 Demo  : ${aws_instance.demo.public_ip}

Add your private key and SSH into any private node via the Bootstrap host:
  ssh-add ${path.cwd}/../keys/10academy.key
CONFIGURATION
}

output "team1_public_ip" {
  value = "${aws_instance.team1.public_ip}"
}

output "team2_public_ip" {
  value = "${aws_instance.team2.public_ip}"
}

output "team3_public_ip" {
  value = "${aws_instance.team3.public_ip}"
}

output "team4_public_ip" {
  value = "${aws_instance.team4.public_ip}"
}

output "team5_public_ip" {
  value = "${aws_instance.team5.public_ip}"
}

output "demo_public_ip" {
  value = "${aws_instance.demo.public_ip}"
}
