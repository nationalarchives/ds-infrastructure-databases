variable "resource_identifier" {}
variable "mysql_main_ebs" {}
variable "mysql_main_availability_zone" {}

# --
# ebs
variable "mysql_main_ebs_volume_size" {}

# --
# instance
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "volume_size" {}
variable "mysql_main_disable_api_termination" {}
variable "monitoring" {}

# --
# iam
variable "s3_deployment_bucket" {}
variable "s3_folder" {}
variable "tags" {}

# --
# network settings
variable "vpc_id" {}
variable "db_subnet_a_id" {}
variable "db_subnet_b_id" {}
variable "db_subnet_cidrs" {}
