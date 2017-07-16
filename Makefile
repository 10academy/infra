.PHONY: all apply destroy help plan

OPS_DIR=.
TERRAFORM_DIR=$(OPS_DIR)/terraform
OPS_SCRIPTS_DIR=$(OPS_DIR)/scripts

all: help

apply:  ## Terraform apply. Usage example: make apply [target=production provider=aws]
	${OPS_SCRIPTS_DIR}/tf-run.sh apply $(target) $(provider)

destroy:  ## Warning!!! Terraform destroy. Usage example: make destroy [target=production provider=aws]
	${OPS_SCRIPTS_DIR}/tf-run.sh destroy $(target) $(provider)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

output:  ## Terraform output. Usage example: make output [target=production provider=aws]
	${OPS_SCRIPTS_DIR}/tf-run.sh output $(target) $(provider)

plan:  ## Terraform plan. Usage example: make plan [target=production provider=aws]
	${OPS_SCRIPTS_DIR}/tf-run.sh plan $(target) $(provider)
