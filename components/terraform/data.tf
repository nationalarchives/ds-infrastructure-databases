data "aws_caller_identity" "current" {}

data "aws_ami" "mysql_main_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "mysql-main-primer-*"
        ]
    }

    filter {
        name   = "virtualization-type"
        values = [
            "hvm"
        ]
    }

    owners = [
        data.aws_caller_identity.current.account_id,
    ]
}

data "aws_ami" "postgres_main_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "postgres-main-primer-*"
        ]
    }

    filter {
        name   = "virtualization-type"
        values = [
            "hvm"
        ]
    }

    owners = [
        data.aws_caller_identity.current.account_id,
    ]
}

data "aws_ssm_parameter" "vpc_id" {
    name = "/infrastructure/network/base/vpc_id"
}

data "aws_ssm_parameter" "public_subnet_a_cidr" {
    name = "/infrastructure/public_subnet_2a_cidr"
}

data "aws_ssm_parameter" "public_subnet_b_cidr" {
    name = "/infrastructure/public_subnet_2b_cidr"
}

data "aws_ssm_parameter" "private_subnet_a_cidr" {
    name = "/infrastructure/private_subnet_2a_cidr"
}

data "aws_ssm_parameter" "private_subnet_b_cidr" {
    name = "/infrastructure/private_subnet_2b_cidr"
}

data "aws_ssm_parameter" "private_db_subnet_a_cidr" {
    name = "/infrastructure/network/base/private_db_subnet_2a_cidr"
}

data "aws_ssm_parameter" "private_db_subnet_a_id" {
    name = "/infrastructure/network/base/private_db_subnet_2a_id"
}

data "aws_ssm_parameter" "private_db_subnet_b_cidr" {
    name = "/infrastructure/network/base/private_db_subnet_2b_cidr"
}

data "aws_ssm_parameter" "private_db_subnet_b_id" {
    name = "/infrastructure/network/base/private_db_subnet_2b_id"
}

data "aws_ssm_parameter" "client_vpn_cidr" {
    name = "/infrastructure/client_vpn_cidr"
}

data "aws_ssm_parameter" "route53_zone_id" {
    name = "/infrastructure/route53/private_zone_id"
}

data "aws_ssm_parameter" "mysql_main_prime_volume_id" {
    name = "/infrastructure/databases/mysql-main-prime/volume_id"
}
data "aws_ssm_parameter" "mysql_main_replica_volume_id" {
    name = "/infrastructure/databases/mysql-main-replica/volume_id"
}

data "aws_ssm_parameter" "postgres_main_prime_volume_id" {
    name = "/infrastructure/databases/postgres-main-prime/volume_id"
}

data "aws_ssm_parameter" "postgres_main_replica_volume_id" {
    name = "/infrastructure/databases/postgres-main-replica/volume_id"
}
