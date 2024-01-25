locals {
    private_beta_sg_name        = "private-beta-sg"
    private_beta_sg_description = "allowing access from private subnets"

    private_beta_ingress_cidr = {
        "priv_a_sub" = {
            "from_port"   = 5432
            "to_port"     = 5432
            "ip_protocol" = "tcp"
            "description" = "private subnet a"
            "cidr_ipv4" = data.aws_ssm_parameter.private_subnet_a_cidr.value
        }
        "priv_b_sub" = {
            "from_port"   = 5432
            "to_port"     = 5432
            "ip_protocol" = "tcp"
            "description" = "private subnet b"
            "cidr_ipv4" = data.aws_ssm_parameter.private_subnet_b_cidr.value
        }
        "client_vpn" = {
            "from_port"   = 5432
            "to_port"     = 5432
            "ip_protocol" = "tcp"
            "description" = "client-vpn"
            "cidr_ipv4" = data.aws_ssm_parameter.client_vpc_cidr.value
        }
    }

    private_beta_ingress_self = {
            "from_port"   = 5432
            "to_port"     = 5432
            "ip_protocol" = "tcp"
            "description" = "group members"
    }

    # outbound CIDR
    #
    private_beta_egress_cidr = {
        "egress" = {
            "from_port"   = 1024
            "to_port"     = 65535
            "ip_protocol" = "tcp"
            "description" = "to everywhere"
            "cidr_ipv4" = "0.0.0.0/0"
        }
    }
}
