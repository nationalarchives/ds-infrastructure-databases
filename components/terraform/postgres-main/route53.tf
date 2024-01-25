variable "private_beta_route53_name" {}
variable "private_beta_route53_type" {}

module "private_beta_route53" {
    source = "route53/private-beta"

    name = var.private_beta_route53_name
    type = var.private_beta_route53_type
    zone_id = data.aws_ssm_parameter.route53_zone_id
}
