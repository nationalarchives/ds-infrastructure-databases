resource "aws_db_instance" "rds_instance" {
    username = jsondecode(data.aws_secretsmanager_secret_version.sql_cluster_credentials.secret_string)["admin"]["username"]
    password = jsondecode(data.aws_secretsmanager_secret_version.sql_cluster_credentials.secret_string)["admin"]["password"]

    publicly_accessible = false

    identifier                = "${var.environment}-sql-cluster"
    final_snapshot_identifier = "${var.environment}-sql-cluster-final"

    allocated_storage    = var.database_storage
    storage_type         = var.database_storage_type
    engine               = var.engine
    engine_version       = var.engine_version
    instance_class       = var.database_instance_class
    db_subnet_group_name = aws_db_subnet_group.default.name
    multi_az             = var.multi_az
    port                 = var.port
    vpc_security_group_ids = [
        aws_security_group.sql_cluster_security_group.id,
    ]
    option_group_name          = aws_db_option_group.sql_options_group.name
    parameter_group_name       = aws_db_parameter_group.mssql_pg.name
    license_model              = var.license_model
    apply_immediately          = var.apply_immediately
    auto_minor_version_upgrade = var.auto_minor_upgrade
    skip_final_snapshot        = var.skip_final_snapshot
    ca_cert_identifier         = var.ca_cert_identifier
    backup_retention_period    = var.backup_retention_period
    backup_window              = "01:00-02:14"

    tags = {
        Environment = var.environment
        Product     = "ms-sql-cluster"
    }
}

# RDS Subnet Group
#
resource "aws_db_subnet_group" "default" {
    name = "${var.environment}-sql-cluster-db-subnet-group"
    subnet_ids = [
        data.aws_ssm_parameter.sql_cluster_subnet_a_id,
        data.aws_ssm_parameter.sql_cluster_subnet_b_id,
    ]

    tags = {
        Environment = var.environment
        Product     = "ms-sql-cluster"
    }
}

# RDS Parameter Group
#
resource "aws_db_parameter_group" "mssql_pg" {
    name   = "${var.environment}-sql-cluster-pg"
    family = var.pg_family

    tags = {
        Environment = var.environment
        Name        = "${var.environment}-sql-cluster-pg"
        Product     = "ms-sql-cluster"
    }

    dynamic parameter {
        for_each = var.parameters
        content {
            name         = parameter.value.name
            value        = parameter.value.value
            apply_method = parameter.value.apply_method
        }
    }
}

# RDS Option Group
#
resource "aws_db_option_group" "sql_options_group" {
    name                     = "${var.environment}-sql-cluster-og"
    option_group_description = var.og_option_group_description
    engine_name              = var.og_engine_name
    major_engine_version     = var.major_engine_version

    tags = {
        Environment = var.environment
        Name        = "${var.environment}-sql-cluster-og"
        Product     = "ms-sql-cluster"
    }

    dynamic option {
        for_each = var.options

        content {
            option_name = option.value.option_name

            dynamic option_settings {
                for_each = option.value.option_settings

                content {
                    name  = option_settings.value.name
                    value = option_settings.value.value
                }
            }
        }
    }
}
