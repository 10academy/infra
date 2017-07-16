#--------------------------------------------------------------
# This module creates github team
#--------------------------------------------------------------

variable "team" {}
variable "members" {}

resource "github_membership" "membership" {
  count = "${length(split(",", var.members))}"
  username  = "${element(split(",", var.members), count.index)}"
  role     = "member"
}

resource "github_team" "team" {
  name        = "${var.team}"
  description = "${var.team}"
}

resource "github_team_membership" "team_membership" {
  team_id  = "${github_team.team.id}"
  count = "${length(split(",", var.members))}"
  username  = "${element(split(",", var.members), count.index)}"
  role     = "member"
}

output "team_members" {
  value = "${join(",", github_membership.membership.*.username)}"
}

output "team_id" {
  value = "${github_team.team.id}"
}
