asm_sql_cluster_arn = "arn:aws:secretsmanager:eu-west-2:846769538626:secret:rds/dev-sql-cluster-rOd9kp"

sql_cluster_database_storage            = 400
sql_cluster_database_storage_type       = "gp2"
sql_cluster_engine                      = "sqlserver-web"
sql_cluster_engine_version              = "15.00"
sql_cluster_database_instance_class     = "db.t3.small"
sql_cluster_port                        = 4333
sql_cluster_multi_az                    = false
sql_cluster_license_model               = "license-included"
sql_cluster_apply_immediately           = true
sql_cluster_auto_minor_upgrade          = true
sql_cluster_backup_retention_period     = 30
sql_cluster_ca_cert_identifier          = "rds-ca-rsa2048-g1"
sql_cluster_skip_final_snapshot         = true
sql_cluster_pg_family                   = "sqlserver-web-15.0"
sql_cluster_og_option_group_description = "options group for ms-sql server 2019 web edition"
sql_cluster_og_engine_name              = "sqlserver-web"
sql_cluster_major_engine_version        = "15.00"

sql_cluster_parameters = [
    {
        name         = "rds.force_ssl"
        value        = 1
        apply_method = "pending-reboot"
    },
    {
        name         = "rds.tls10"
        value        = "disabled"
        apply_method = "pending-reboot"
    },
    {
        name         = "rds.tls11"
        value        = "disabled"
        apply_method = "pending-reboot"
    },
    {
        name         = "rds.rc4"
        value        = "disabled"
        apply_method = "pending-reboot"
    }
]

sql_cluster_options = [
    {
        option_name = "SQLSERVER_BACKUP_RESTORE",
        option_settings = [
            {
                name  = "IAM_ROLE_ARN"
                value = "arn:aws:iam::846769538626:role/rds-import-export-role"
            }
        ]
    }
]

sql_cluster_ingress_rules_tcp_rules = [
    {
        "from_port"   = 4333
        "to_port"     = 4333
        "description" = "access from private subnets"
        "name"        = "priv_subs"
        "cidr_ipv4"   = "10.128.210.0/23"
    },
    {
        "from_port"   = 4333
        "to_port"     = 4333
        "description" = "access from client-vpn"
        "name"        = "intersite"
        "cidr_ipv4"   = "10.128.224.0/21"
    },
    {
        "from_port"   = 4333
        "to_port"     = 4333
        "description" = "access from onprem SQL Servers"
        "name"        = "sql_onprem"
        "cidr_ipv4"   = "10.112.130.0/24"
    },
    "{
        "from_port"   = 4333
        "to_port"     = 4333
        "description" = "access from kew lobapp servers"
        "name"        = "lobapp"
        "cidr_ipv4"   = "10.112.120.0/24"
    },
    {
        "from_port"   = 4333
        "to_port"     = 4333
        "description" = "access from kew lobapp servers"
        "name"        = "lobapp_two"
        "cidr_ipv4"   = "172.31.2.0/24"
    },
    {
        "from_port"   = 4333
        "to_port"     = 4333
        "description" = "access from kew developer nw"
        "name"        = "kew_devs"
        "cidr_ipv4"   = "10.120.2.0/24"
    },
    {
        "from_port"   = 3343
        "to_port"     = 3343
        "protocol"    = "-1"
        "description" = "multi-az db replication"
        "name"        = "replication_3343"
        "cidr_ipv4"   = "10.128.212.0/23"
    },
]

sql_cluster_egress_rules_tcp_rules = [
    {
        "from_port"   = 4333
        "to_port"     = 4333
        "description" = "sql access to everywhere"
        "name"        = "http"
        "cidr_ipv4"   = "0.0.0.0/0"
    },
    {
        "from_port"   = 443
        "to_port"     = 443
        "description" = "https access to everywhere"
        "name"        = "https"
        "cidr_ipv4"   = "0.0.0.0/0"
    },
    {
        "from_port"   = 3343
        "to_port"     = 3343
        "protocol"    = "-1"
        "description" = "multi-az db replication"
        "name"        = "replication_3343"
        "cidr_ipv4"   = "10.128.212.0/23"
    },
    {
        "from_port"   = 1024
        "to_port"     = 65535
        "description" = "traffic to all VPCs"
        "name"        = "vpcs"
        "cidr_ipv4"   = "10.128.0.0/16"
    },
    {
        "from_port"   = 4333
        "to_port"     = 4334
        "description" = "access to onprem SQL servers"
        "name"        = "onprem"
        "cidr_ipv4"   = "10.112.130.0/24"
    },
]
