module "private-beta-sgs" {
    source = "./security-groups/private-beta"

    name        = "private-beta-postgres-sg"
    description = "access to postgres"

    vpc_id = data.aws_ssm_parameter.vpc_id.value

    ingress      = local.private_beta_ingress_cidr
    ingress_self = local.private_beta_ingress_self
    egress       = local.private_beta_egress_cidr

    tags = local.tags
}
