variable "name" {}
variable "description" {}
variable "vpc_id" {}
variable "ingress" {}
variable "ingress_sg" {}
variable "egress" {}
variable "tags" {}

resource "aws_security_group" "postgres" {
    name        = var.name
    description = var.description
    vpc_id      = var.vpc_id

    tags = merge(var.tags, {
        Name = var.name
    })
}

resource "aws_vpc_security_group_ingress_rule" "cidr" {
    security_group_id = aws_security_group.postgres.id

    for_each    = var.ingress
    cidr_ipv4   = lookup(each.value, "cidr_ipv4", null)
    description = lookup(each.value, "description", "")
    from_port   = lookup(each.value, "from_port", "")
    ip_protocol = lookup(each.value, "ip_protocol", "tcp")
    to_port     = lookup(each.value, "to_port", "")
}

resource "aws_vpc_security_group_ingress_rule" "sg_id" {
    security_group_id = aws_security_group.postgres.id

    for_each    = var.ingress
    description = lookup(each.value, "description", "")
    from_port   = lookup(each.value, "from_port", "")
    ip_protocol = lookup(each.value, "ip_protocol", "tcp")
    referenced_security_group_id = lookup(each.value, "referenced_security_group_id", aws_security_group.postgres.id)
    to_port     = lookup(each.value, "to_port", "")
}

resource "aws_vpc_security_group_egress_rule" "cidr" {
    security_group_id = aws_security_group.postgres.id

    for_each = var.egress
    cidr_ipv4   = lookup(each.value, "cidr_ipv4", "")
    description = lookup(each.value, "description", "")
    from_port   = lookup(each.value, "from_port", "")
    ip_protocol = lookup(each.value, "ip_protocol", "")
    to_port     = lookup(each.value, "to_port", "")
}
