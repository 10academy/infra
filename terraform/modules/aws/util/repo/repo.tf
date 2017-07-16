#--------------------------------------------------------------
# This module creates all app repos
#--------------------------------------------------------------

variable "name" {}

resource "aws_ecr_repository" "repo" {
  //  count = "${length(split(",", var.repos))}"
  name = "${var.name}"
}

resource "aws_ecr_repository_policy" "policy" {
  //  count      = "${length(split(",", var.repos))}"
  repository = "${aws_ecr_repository.repo.name}"

  policy     = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}

output "repo_url" {
  value = "${aws_ecr_repository.repo.repository_url}"
}

output "policy" {
  value = "${aws_ecr_repository_policy.policy.id}"
}
