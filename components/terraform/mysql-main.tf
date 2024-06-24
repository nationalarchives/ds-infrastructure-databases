variable "mysql_main_prime" {}
variable "mysql_main_replica" {}

variable "mysql_main_key_name" {}

variable "mysql_main_instance_type" {}
variable "mysql_main_volume_size" {}
variable "mysql_main_disable_api_termination" {}
variable "mysql_main_monitoring" {}

variable "mysql_main_auto_switch_on" {}
variable "mysql_main_auto_switch_off" {}

variable "mysql_main_prime_dns" {}
variable "mysql_main_replica_dns" {}

module "mysql-main-prime" {
    source = "./mysql-main"

    count = var.mysql_main_prime == true ? 1 : 0

    resource_identifier = "main-prime"

    mysql_main_availability_zone = "eu-west-2a"

    account_id = data.aws_caller_identity.current.account_id
    mysql_secret_id = "/infrastructure/credentials/mysql-main"

    # iam
    s3_deployment_bucket         = "ds-${var.environment}-deployment-source"
    s3_folder                    = "databases/mysql"
    backup_bucket                = "ds-${var.environment}-backups"
    attach_ebs_volume_policy_arn = module.iam_policies.attach_volume_policy_arn

    # instances
    ami_id        = data.aws_ami.mysql_main_ami.id
    instance_type = var.mysql_main_instance_type
    volume_size   = var.mysql_main_volume_size
    key_name      = var.mysql_main_key_name

    mysql_ami_build_sg_id = module.security-groups.mysql_ami_build_sg_id

    disable_api_termination = var.mysql_main_disable_api_termination
    monitoring              = var.mysql_main_monitoring

    attached_ebs_volume_id = data.aws_ssm_parameter.mysql_main_prime_volume_id.value

    # network
    vpc_id          = data.aws_ssm_parameter.vpc_id.value
    db_subnet_cidrs = [
        data.aws_ssm_parameter.private_db_subnet_a_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_b_cidr.value,
        data.aws_ssm_parameter.client_vpn_cidr.value,
        data.aws_ssm_parameter.private_subnet_a_cidr.value,
        data.aws_ssm_parameter.private_subnet_b_cidr.value,
        data.aws_ssm_parameter.public_subnet_a_cidr.value,
        data.aws_ssm_parameter.public_subnet_b_cidr.value,
    ]
    db_subnet_id = data.aws_ssm_parameter.private_db_subnet_a_id.value

    zone_id   = data.aws_ssm_parameter.route53_zone_id.value
    mysql_dns = var.mysql_main_prime_dns

    auto_switch_on  = var.mysql_main_auto_switch_on
    auto_switch_off = var.mysql_main_auto_switch_off

    tags = merge(local.tags, {
        Product = "MySQL"
    })
}

module "mysql-main-replica" {
    source = "./mysql-main"

    count = alltrue([var.mysql_main_prime, var.mysql_main_replica]) ? 1 : 0

    resource_identifier = "main-replica"

    mysql_main_availability_zone = "eu-west-2b"

    account_id = data.aws_caller_identity.current.account_id
    mysql_secret_id = "/infrastructure/credentials/mysql-main"

    # iam
    s3_deployment_bucket         = "ds-${var.environment}-deployment-source"
    s3_folder                    = "databases/mysql"
    backup_bucket                = "ds-${var.environment}-backups"
    attach_ebs_volume_policy_arn = module.iam_policies.attach_volume_policy_arn

    # instances
    ami_id        = data.aws_ami.mysql_main_ami.id
    instance_type = var.mysql_main_instance_type
    volume_size   = var.mysql_main_volume_size
    key_name      = var.mysql_main_key_name

    mysql_ami_build_sg_id = module.security-groups.mysql_ami_build_sg_id

    disable_api_termination = var.mysql_main_disable_api_termination
    monitoring              = var.mysql_main_monitoring

    attached_ebs_volume_id = data.aws_ssm_parameter.mysql_main_replica_volume_id.value

    # network
    vpc_id          = data.aws_ssm_parameter.vpc_id.value
    db_subnet_cidrs = [
        data.aws_ssm_parameter.private_subnet_a_cidr.value,
        data.aws_ssm_parameter.private_subnet_b_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_a_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_b_cidr.value,
        data.aws_ssm_parameter.client_vpn_cidr.value,
    ]
    db_subnet_id = data.aws_ssm_parameter.private_db_subnet_b_id.value

    zone_id   = data.aws_ssm_parameter.route53_zone_id.value
    mysql_dns = var.mysql_main_replica_dns

    auto_switch_on  = var.mysql_main_auto_switch_on
    auto_switch_off = var.mysql_main_auto_switch_off

    tags = merge(local.tags, {
        Product = "MySQL"
    })
}
