variable "resource_identifier" {}
variable "availability_zone" {}

# --
# instance
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "volume_size" {}
variable "disable_api_termination" {}
variable "monitoring" {}

variable "postgres_ami_build_sg_id" {}

variable "auto_switch_on" {}
variable "auto_switch_off" {}

# --
# iam
variable "s3_deployment_bucket" {}
variable "s3_folder" {}
variable "backup_bucket" {}

variable "tags" {}

# --
# DNS
variable "zone_id" {}
variable "postgres_dns_main_prime" {}

# --
# network settings
variable "vpc_id" {}
variable "db_subnet_id" {}
variable "db_subnet_cidrs" {}
