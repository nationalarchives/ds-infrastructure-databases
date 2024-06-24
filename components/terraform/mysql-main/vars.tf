variable "resource_identifier" {}
variable "mysql_main_availability_zone" {}

variable "account_id" {}

# --
# instance
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "volume_size" {}
variable "disable_api_termination" {}
variable "monitoring" {}

variable "mysql_ami_build_sg_id" {}

variable "auto_switch_on" {}
variable "auto_switch_off" {}

variable "attached_ebs_volume_id" {}

variable "mysql_secret_id" {}

# --
# iam
variable "s3_deployment_bucket" {}
variable "s3_folder" {}
variable "backup_bucket" {}
variable "attach_ebs_volume_policy_arn" {}

variable "tags" {}

# --
# DNS
variable "mysql_dns" {}
variable "zone_id" {}

# --
# network settings
variable "vpc_id" {}
variable "db_subnet_id" {}
variable "db_subnet_cidrs" {}
