variable "name" {}
variable "type" {}
variable "zone_id" {}

resource "aws_route53_record" "private_beta_db" {
    name    = var.name
    type    = var.type
    zone_id = var.zone_id
}
