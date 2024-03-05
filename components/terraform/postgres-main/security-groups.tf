resource "aws_security_group" "postgres_main" {
    name        = "postgres-${var.resource_identifier}-sg"
    description = "allow access to prime over postgres port"
    vpc_id      = var.vpc_id

    lifecycle {
        create_before_destroy = true
    }

    tags = merge(var.tags, {
        Name = "postgres-${var.resource_identifier}-sg"
    })
}

resource "aws_vpc_security_group_ingress_rule" "self_ingress" {
    security_group_id = aws_security_group.postgres_main.id

    referenced_security_group_id = aws_security_group.postgres_main.id
    from_port                    = 3306
    ip_protocol                  = "tcp"
    to_port                      = 3306
}

resource "aws_vpc_security_group_ingress_rule" "db_port_ingress" {
    count = length(var.db_subnet_cidrs)

    security_group_id = aws_security_group.postgres_main.id

    cidr_ipv4   = var.db_subnet_cidrs[count.index]
    from_port   = 3306
    ip_protocol = "tcp"
    to_port     = 3306
}

resource "aws_vpc_security_group_egress_rule" "http_egress" {
    security_group_id = aws_security_group.postgres_main.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 80
    ip_protocol = "tcp"
    to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "https_egress" {
    security_group_id = aws_security_group.postgres_main.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 443
    ip_protocol = "tcp"
    to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "all_egress" {
    security_group_id = aws_security_group.postgres_main.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 49152
    ip_protocol = "tcp"
    to_port     = 65535
}

