variable "mongodb_org_id" {
    description = "The MongoDB Atlas Organization ID"
    type        = string
    default     = data.aws_ssm_parameter.mongodb_org_id.value
}

resource "mongodbatlas_team" "platform_team" {
    name   = "Platform Team"
    org_id = var.mongodb_org_id
}

resource "mongodbatlas_team" "developer_team" {
    name   = "Developer Team"
    org_id = var.mongodb_org_id
}

