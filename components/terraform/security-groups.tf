module "private-beta-sgs" {
    source = "./security-groups/private-beta"

    name        = "private-beta-postgres-sg"
    description = "access to postgres"

    vpc_id = data.aws_ssm_parameter.vpc_id.value

    ingress    = local.private_beta_ingress
    ingress_sg = local.private_beta_ingress_sg
    egress     = local.private_beta_egress

    tags = local.tags
}
