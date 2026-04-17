data "aws_ssm_parameter" "mongodb_org_id" {
    provider = aws.intersite
    name = "/infrastructure/databases/mongodb/atlas_org_id"
}

