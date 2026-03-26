# ------------------------------------------------------------------------------
# MongoDB sources
# ------------------------------------------------------------------------------

data "aws_ssm_parameter" "atlas_platform_team_id" {
    provider = aws.intersite
    name = "/infrastructure/databases/mongodb/atlas_platform_team_id"
}

data "aws_ssm_parameter" "atlas_developer_team_id" {
    provider = aws.intersite
    name = "/infrastructure/databases/mongodb/atlas_developer_team_id"
}

data "aws_ssm_parameter" "mongodb_org_id" {
    provider = aws.intersite
    name = "/infrastructure/databases/mongodb/atlas_org_id"
}

# ------------------------------------------------------------------------------
# Kew CIDR Ranges
# ------------------------------------------------------------------------------
data "aws_ssm_parameter" "kew_developer_network" {
    provider = aws.intersite
    name = "/infrastructure/on-prem/networks/kew_developer_network"
}

data "aws_ssm_parameter" "kew_app_network" {
    provider = aws.intersite
    name = "/infrastructure/on-prem/networks/kew_app_network"
}

data "aws_ssm_parameter" "kew_new_test_app_network" {
    provider = aws.intersite
    name = "/infrastructure/on-prem/networks/kew_new_test_app_network"
}

data "aws_ssm_parameter" "kew_new_live_app_network" {
    provider = aws.intersite
    name = "/infrastructure/on-prem/networks/kew_new_live_app_network"
}

data "aws_ssm_parameter" "kew_wvd_network" {
    provider = aws.intersite
    name = "/infrastructure/on-prem/networks/kew_wvd_network"
}

data "aws_ssm_parameter" "london_client_vpn_network" {
    provider = aws.intersite
    name = "/infrastructure/networks/vpn/dsintersite_vpc_cidr"
}
