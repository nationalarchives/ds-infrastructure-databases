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

resource "aws_vpc_security_group_ingress_rule" "self_ingress" {
    security_group_id = aws_security_group.mysql_main.id

    referenced_security_group_id = aws_security_group.mysql_main.id
    from_port                    = 3306
    ip_protocol                  = "tcp"
    to_port                      = 3306
}

resource "aws_vpc_security_group_ingress_rule" "db_port_ingress" {
    count = length(var.db_subnet_cidrs)

    security_group_id = aws_security_group.mysql_main.id

    cidr_ipv4   = toset(var.db_subnet_cidrs[count.index])
    from_port   = 3306
    ip_protocol = "tcp"
    to_port     = 3306
}

resource "aws_vpc_security_group_egress_rule" "all_egress" {
    security_group_id = aws_security_group.mysql_main.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = -1
    ip_protocol = "-1"
    to_port     = -1
}

# security group to allow access to the database from public subnets when
# building the AMI;
resource "aws_security_group" "mysql_main_ami" {
    name        = "mysql-ami-build-sg"
    description = "allow access to prime for ami build"
    vpc_id      = var.vpc_id

    lifecycle {
        create_before_destroy = true
    }

    tags = merge(var.tags, {
        Name = "mysql-ami-build-sg"
    })
}

resource "aws_vpc_security_group_ingress_rule" "ami_ingress" {
    security_group_id = aws_security_group.mysql_main_ami.id

    referenced_security_group_id = aws_security_group.mysql_main_ami.id
    from_port                    = 3306
    ip_protocol                  = "tcp"
    to_port                      = 3306
}

resource "aws_vpc_security_group_egress_rule" "ami_egress" {
    security_group_id = aws_security_group.mysql_main_ami.id

    referenced_security_group_id = aws_security_group.mysql_main_ami.id
    from_port   = 1024
    ip_protocol = "tcp"
    to_port     = 65535
}
