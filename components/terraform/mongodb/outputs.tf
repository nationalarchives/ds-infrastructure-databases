output "mongodbatlas_cloud_provider_access_setup_arn" {
    value = mongodbatlas_cloud_provider_access_setup.role.aws_config[0].atlas_aws_account_arn
}

output "atlas_assumed_role_external_id" {
    value = mongodbatlas_cloud_provider_access_setup.role.aws_config[0].atlas_assumed_role_external_id
}
