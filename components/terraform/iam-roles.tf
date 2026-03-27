module "iam_roles" {
    source = "./iam/roles"
    mongodbatlas_cloud_provider_access_setup_arn = module.mongodb.outputs.mongodbatlas_cloud_provider_access_setup_arn.value
    external_id = module.mongodb.outputs.atlas_assumed_role_external_id.value
}
