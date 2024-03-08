variable "postgres_main_prime" {}
variable "postgres_main_replica" {}

variable "postgres_main_prime_key_name" {}
variable "postgres_main_replica_key_name" {}

variable "postgres_main_instance_type" {}
variable "postgres_main_volume_size" {}
variable "postgres_main_disable_api_termination" {}
variable "postgres_main_monitoring" {}

variable "postgres_main_auto_switch_on" {}
variable "postgres_main_auto_switch_off" {}

variable "postgres_main_prime_dns" {}
variable "postgres_main_replica_dns" {}

module "postgres-main-prime" {
    source = "./postgres-main"

    count = var.postgres_main_prime == true ? 1 : 0

    resource_identifier = "main-prime"

    availability_zone = "eu-west-2a"

    # iam
    s3_deployment_bucket         = "ds-${var.environment}-deployment-source"
    s3_folder                    = "databases/postgres"
    backup_bucket                = "ds-${var.environment}-backup"
    attach_ebs_volume_policy_arn = module.iam_policies.attach_volume_policy_arn

    # instances
    ami_id        = data.aws_ami.postgres_main_ami.id
    instance_type = var.postgres_main_instance_type
    volume_size   = var.postgres_main_volume_size
    key_name      = var.postgres_main_prime_key_name

    postgres_ami_build_sg_id = module.security-groups.postgres_ami_build_sg_id

    disable_api_termination = var.postgres_main_disable_api_termination
    monitoring              = var.postgres_main_monitoring

    # network
    vpc_id          = data.aws_ssm_parameter.vpc_id.value
    db_subnet_cidrs = [
        data.aws_ssm_parameter.private_subnet_a_cidr.value,
        data.aws_ssm_parameter.private_subnet_b_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_a_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_b_cidr.value,
        data.aws_ssm_parameter.client_vpn_cidr.value,
    ]
    db_subnet_id = data.aws_ssm_parameter.private_db_subnet_a_id.value

    zone_id                 = data.aws_ssm_parameter.route53_zone_id.value
    postgres_main_prime_dns = var.postgres_main_prime_dns

    auto_switch_on  = var.postgres_main_auto_switch_on
    auto_switch_off = var.postgres_main_auto_switch_off

    tags = merge(local.tags, {
        Product = "Postgres"
    })
}
