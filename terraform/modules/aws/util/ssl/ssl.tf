#--------------------------------------------------------------
# This module is used to create the default ssl certs
#--------------------------------------------------------------

variable "name" {}
variable "env" {}

resource "aws_iam_server_certificate" "main_cert" {
  name             = "ssl-${var.name}-${var.env}"
  certificate_body = "${file("${path.module}/keys/cert.cer")}"
  private_key      = "${file("${path.module}/keys/private.key")}"
}

output "main_cert_id" {
  value = "${aws_iam_server_certificate.main_cert.id}"
}

output "main_cert_arn" {
  value = "${aws_iam_server_certificate.main_cert.arn}"
}

output "main_cert" {
  value = "${aws_iam_server_certificate.main_cert.certificate_chain}"
}

output "main_cert_key" {
  value = "${aws_iam_server_certificate.main_cert.private_key}"
}
