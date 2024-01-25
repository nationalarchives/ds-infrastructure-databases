resource "aws_security_group" "mysql_main" {
    name        = "mysql-main-${var.resource_identifier}-sg"
    description = "allow access to prime over mysql port"
    vpc_id      = var.vpc_id

    lifecycle {
        create_before_destroy = true
    }

    tags = merge(var.tags, {
        Name = "mysql-main-${var.resource_identifier}-sg"
    })
}

resource "aws_vpc_security_group_ingress_rule" "prime_self_ingress" {
    security_group_id = aws_security_group.mysql_main.id

    referenced_security_group_id = aws_security_group.mysql_main.id
    from_port                    = 3306
    ip_protocol                  = "tcp"
    to_port                      = 3306
}

resource "aws_vpc_security_group_ingress_rule" "prime_db_port_ingress" {
    for_each = var.db_subnet_cidrs

    cidr_ipv4   = "${each.value}"
    from_port   = 3306
    ip_protocol = "tcp"
    to_port     = 3306
}

resource "aws_vpc_security_group_egress_rule" "prime_all_egress" {
    security_group_id = aws_security_group.mysql_main.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 0
    ip_protocol = "-1"
    to_port     = 0
}
