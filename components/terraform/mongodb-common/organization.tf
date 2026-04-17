resource "mongodbatlas_team" "platform_team" {
    name   = "Platform Team"
    org_id = data.aws_ssm_parameter.mongodb_org_id.value
}

resource "aws_ssm_parameter" "mongodb_platform_team_id" {
    provider = aws.intersite
    name  = "/infrastructure/databases/mongodb/atlas_platform_team_id"
    type  = "String"
    value = mongodbatlas_team.platform_team.id
}

resource "mongodbatlas_team" "developer_team" {
    name   = "Developer Team"
    org_id = data.aws_ssm_parameter.mongodb_org_id.value
}

resource "aws_ssm_parameter" "mongodb_developer_team_id" {
    provider = aws.intersite
    name  = "/infrastructure/databases/mongodb/atlas_developer_team_id"
    type  = "String"
    value = mongodbatlas_team.developer_team.id
}

