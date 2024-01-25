variable "mysql_main_prime" {}
variable "mysql_main_replica" {}
variable "mysql_main_prime_ebs" {}
variable "mysql_main_replica_ebs" {}

variable "mysql_main_instance_type" {}
variable "mysql_main_volume_size" {}
variable "mysql_main_key_name" {}
variable "mysql_main_disable_api_termination" {}
variable "monitoring" {}

variable "mysql_main_ebs_volume_size" {}

variable "mysql_dns" {}

module "mysql-main-prime" {
    source = "mysql-main"

    count = var.mysql_main_prime == true ? 1 : 0

    resource_identifier = "prime"

    mysql_main_ebs               = alltrue([var.mysql_main_prime, var.mysql_main_prime_ebs]) ? 1 : 0
    mysql_main_availability_zone = "eu-west-2a"

    # iam
    s3_deployment_bucket = "ds-${var.environment}-deployment-source"
    s3_folder            = "databases/mysql"

    # instances
    ami_id        = data.aws_ami.mysql_main_ami.id
    instance_type = var.mysql_main_instance_type
    volume_size   = var.mysql_main_volume_size
    key_name      = var.mysql_main_key_name

    mysql_main_disable_api_termination = var.mysql_main_disable_api_termination
    monitoring                         = var.monitoring

    # ebs
    mysql_main_ebs_volume_size = var.mysql_main_ebs_volume_size

    # network
    vpc_id          = data.aws_ssm_parameter.vpc_id
    db_subnet_cidrs = [
        data.aws_ssm_parameter.private_db_subnet_a_cidr,
        data.aws_ssm_parameter.private_db_subnet_b_cidr,
        data.aws_ssm_parameter.client_vpc_cidr,
        data.aws_ssm_parameter.private_subnet_a_cidr,
        data.aws_ssm_parameter.private_subnet_b_cidr,
    ]
    db_subnet_a_id = data.aws_ssm_parameter.private_db_subnet_a_id
    db_subnet_b_id = data.aws_ssm_parameter.private_db_subnet_b_id

    mysql_dns = var.mysql_dns

    tags = merge(local.tags, {
        Product = "MySQL"
    })
}

module "mysql-main-replica" {
    source = "./mysql-main"

    count = alltrue([var.mysql_main_prime, var.mysql_main_replica]) ? 1 : 0

    resource_identifier = "replica"

    mysql_main_ebs               = var.mysql_main_replica_ebs == true ? 1 : 0
    mysql_main_availability_zone = "eu-west-2b"

    # iam
    s3_deployment_bucket = "ds-${var.environment}-deployment-source"
    s3_folder            = "databases/mysql"

    # instances
    ami_id        = data.aws_ami.mysql_main_ami.id
    instance_type = var.mysql_main_instance_type
    volume_size   = var.mysql_main_volume_size
    key_name      = var.mysql_main_key_name

    mysql_main_disable_api_termination = var.mysql_main_disable_api_termination
    monitoring                         = var.monitoring

    # ebs
    mysql_main_ebs_volume_size = var.mysql_main_ebs_volume_size

    # network
    vpc_id          = data.aws_ssm_parameter.vpc_id
    db_subnet_cidrs = [
        data.aws_ssm_parameter.private_db_subnet_a_cidr,
        data.aws_ssm_parameter.private_db_subnet_b_cidr,
        data.aws_ssm_parameter.client_vpc_cidr,
    ]
    db_subnet_a_id = data.aws_ssm_parameter.private_db_subnet_a_id
    db_subnet_b_id = data.aws_ssm_parameter.private_db_subnet_b_id

    tags = merge(local.tags, {
        Product = "MySQL"
    })
}