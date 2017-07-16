#--------------------------------------------------------------
# This module is used to create the default key pairs
#--------------------------------------------------------------

variable "env" {}

resource "aws_key_pair" "main" {
  key_name   = "kp-${var.env}-manny"
  public_key = "${file("${path.module}/keys/manny.pub")}"
}

output "default_key_name" {
  value = "${aws_key_pair.main.key_name}"
}

output "default_key_id" {
  value = "${aws_key_pair.main.id}"
}

output "default_key" {
  value = "${aws_key_pair.main.public_key}"
}
