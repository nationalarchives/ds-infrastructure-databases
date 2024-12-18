variable "asm_sql_cluster_arn" {}
variable "sql_cluster_database_storage" {}
variable "sql_cluster_database_storage_type" {}
variable "sql_cluster_engine" {}
variable "sql_cluster_engine_version" {}
variable "sql_cluster_database_instance_class" {}
variable "sql_cluster_port" {}
variable "sql_cluster_multi_az" {}
variable "sql_cluster_license_model" {}
variable "sql_cluster_apply_immediately" {}
variable "sql_cluster_auto_minor_upgrade" {}
variable "sql_cluster_backup_retention_period" {}
variable "sql_cluster_ca_cert_identifier" {}
variable "sql_cluster_skip_final_snapshot" {}
variable "sql_cluster_parameters" {}
variable "sql_cluster_options" {}
variable "sql_cluster_og_option_group_description" {}
variable "sql_cluster_og_engine_name" {}
variable "sql_cluster_major_engine_version" {}
variable "sql_cluster_pg_family" {}

variable "sql_cluster_ingress_rules_tcp_rules" {}
variable "sql_cluster_egress_rules_tcp_rules" {}

module "sql-cluster" {
    source = "./rds/microsoft-sql-servers/sql-cluster"

    asm_sql_cluster_arn = var.asm_sql_cluster_arn

    database_storage            = var.sql_cluster_database_storage
    database_storage_type       = var.sql_cluster_database_storage_type
    engine                      = var.sql_cluster_engine
    engine_version              = var.sql_cluster_engine_version
    database_instance_class     = var.sql_cluster_database_instance_class
    port                        = var.sql_cluster_port
    multi_az                    = var.sql_cluster_multi_az
    license_model               = var.sql_cluster_license_model
    apply_immediately           = var.sql_cluster_apply_immediately
    auto_minor_upgrade          = var.sql_cluster_auto_minor_upgrade
    backup_retention_period     = var.sql_cluster_backup_retention_period
    ca_cert_identifier          = var.sql_cluster_ca_cert_identifier
    skip_final_snapshot         = var.sql_cluster_skip_final_snapshot
    parameters                  = var.sql_cluster_parameters
    options                     = var.sql_cluster_options
    og_option_group_description = var.sql_cluster_og_option_group_description
    og_engine_name              = var.sql_cluster_og_engine_name
    major_engine_version        = var.sql_cluster_major_engine_version
    pg_family                   = var.sql_cluster_pg_family

    ingress_rules_tcp_rules = var.sql_cluster_ingress_rules_tcp_rules
    egress_rules_tcp_rules  = var.sql_cluster_egress_rules_tcp_rules

    environment = var.environment
}
