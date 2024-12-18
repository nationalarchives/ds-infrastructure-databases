variable "environment" {}

variable "asm_sql_cluster_arn" {}

variable "database_storage" {}
variable "database_storage_type" {}
variable "engine" {}
variable "engine_version" {}
variable "database_instance_class" {}
variable "port" {}
variable "multi_az" {}
variable "license_model" {}
variable "apply_immediately" {}
variable "auto_minor_upgrade" {}
variable "backup_retention_period" {}
variable "ca_cert_identifier" {}
variable "skip_final_snapshot" {}
variable "parameters" {}
variable "options" {}
variable "og_option_group_description" {}
variable "og_engine_name" {}
variable "major_engine_version" {}
variable "pg_family" {}

variable "vpc_security_group_ids" {}

variable "ingress_rules_tcp_rules" {}
variable "egress_rules_tcp_rules" {}
