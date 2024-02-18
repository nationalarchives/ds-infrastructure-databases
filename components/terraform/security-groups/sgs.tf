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
