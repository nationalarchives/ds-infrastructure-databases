module "security-groups" {
    source = "./security-groups"

    vpc_id = data.aws_ssm_parameter.vpc_id.value

    tags = merge(local.tags, {
        Product = "MySQL"
    })
}
