module "iam_roles" {
    source = "./iam/roles"
    mongodbatlas_cloud_provider_access_setup_arn = module.mongodb.outputs.mongodbatlas_cloud_provider_access_setup_arn.value
}
