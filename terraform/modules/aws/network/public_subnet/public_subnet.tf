#--------------------------------------------------------------
# This module creates all resources necessary for a public
# subnet
#--------------------------------------------------------------

variable "name" {}

variable "vpc_id" {}
variable "cidrs" {}
variable "azs" {}

variable "default_tags" {
  type = "map"
}

resource "aws_internet_gateway" "public" {
  vpc_id = "${var.vpc_id}"

  tags   = "${merge(var.default_tags, map("Name", "ig-public"))}"
}

resource "aws_subnet" "public" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${element(split(",", var.cidrs), count.index)}"
  availability_zone       = "${element(split(",", var.azs), count.index)}"
  count                   = "${length(split(",", var.cidrs))}"

  lifecycle {
    create_before_destroy = true
  }

  map_public_ip_on_launch = true

  tags                    = "${merge(var.default_tags, map("Name", "sn-public"))}"
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags   = "${merge(var.default_tags, map("Name", "rt-public"))}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(split(",", var.cidrs))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

output "subnet_ids" {
  value = "${join(",", aws_subnet.public.*.id)}"
}
