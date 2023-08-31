locals {
    private_beta_ingress = [
        {
            "cidr_ipv4"   = data.aws_ssm_parameter.private_subnet_a_cidr
            "description" = "access from private a subnets"
            "from_port"   = 5432
            "ip_protocol" = "tcp"
            "to_port"     = 5432
        },
        {
            "cidr_ipv4"   = data.aws_ssm_parameter.private_subnet_b_cidr
            "description" = "access from private b subnets"
            "from_port"   = 5432
            "ip_protocol" = "tcp"
            "to_port"     = 5432
        },
    ]
    private_beta_ingress_sg = [
        {
            "description"                  = "access for security group members"
            "from_port"                    = 5432
            "to_port"                      = 5432
        },
    ]
    private_beta_egress = [
        {
            "cidr_ipv4"   = "0.0.0.0/0"
            "description" = "for outbound traffic"
            "from_port"   = 1024
            "to_port"     = 65535
        }
    ]
}
