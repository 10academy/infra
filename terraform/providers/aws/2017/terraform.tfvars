#--------------------------------------------------------------
# General
#--------------------------------------------------------------

name                 = "10academy"
region               = "eu-west-1"
sub_domain           = "2017"

#--------------------------------------------------------------
# Network
#--------------------------------------------------------------

vpc_cidr             = "10.0.0.0/16"
azs                  = "eu-west-1a" # AZs are region specific
public_subnets       = "10.0.1.0/24" # Creating one public subnet per AZ

#--------------------------------------------------------------
# App
#--------------------------------------------------------------
env                  = "2017"
default_tags         = {
  Environment = "2017"
}

sub_domain           = "2017"


instance_port        = 80
instance_type        = "t1.micro"

tf_bucket            = "10academy-terraform-infrastructure"
tf_state_file        = "aws/2017/terraform.tfstate"
tf_state_file_global = "aws/global/terraform.tfstate"
