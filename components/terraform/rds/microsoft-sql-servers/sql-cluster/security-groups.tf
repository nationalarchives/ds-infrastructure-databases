resource "aws_security_group" "sql_cluster_security_group" {
    name        = "sql-cluster-sg"
    description = "allowing access from private subnets"
    vpc_id      = data.aws_ssm_parameter.sql_cluster_vpc_id

    tags = {
        Environment = var.environment
        Name        = "sql-cluster-sg"
    }
}

resource "aws_vpc_security_group_ingress_rule" "sql_cluster_tcp_ingress" {
    security_group_id = aws_security_group.sql_cluster_security_group.id

    referenced_security_group_id = aws_security_group.sql_cluster_security_group.id

    from_port   = 4333
    ip_protocol = "tcp"
    to_port     = 4333
    tags = {
        Name = "self"
    }
}

resource "aws_vpc_security_group_ingress_rule" "sql_cluster_tcp_ingress" {
    for_each = var.ingress_rules_tcp_rules

    security_group_id = aws_security_group.sql_cluster_security_group.id

    cidr_ipv4 = lookup(each.value, "cidr_ipv4", "")
    from_port = lookup(each.value, "from_port", 1433)
    ip_protocol = "tcp"
    to_port = lookup(each.value, "to_port", 1433)
    tags = {
        Name = lookup(each.value, "name", "")
    }
}

resource "aws_vpc_security_group_egress_rule" "example" {
    for_each = var.egress_rules_tcp_rules

    security_group_id = aws_security_group.sql_cluster_security_group.id

    cidr_ipv4 = lookup(each.value, "cidr_ipv4", "")
    from_port = lookup(each.value, "from_port", 443)
    ip_protocol = "tcp"
    to_port = lookup(each.value, "to_port", 443)
    tags = {
        Name = lookup(each.value, "name", "")
    }
}

