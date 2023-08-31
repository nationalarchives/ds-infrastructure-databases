data "aws_ssm_parameter" "vpc_id" {
    name = "/infrastructure/network/base/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_a_cidr" {
    name = "/infrastructure/private_subnet_2a_cidr"
}

data "aws_ssm_parameter" "private_subnet_b_cidr" {
    name = "/infrastructure/private_subnet_2b_cidr"
}


data "aws_ssm_parameter" "client_vpc_cidr" {
    name = "/infrastructure/vpc_cidr"
}

