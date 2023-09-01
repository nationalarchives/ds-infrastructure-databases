variable "s3_deployment_bucket_arn" {}
variable "private_beta_s3_folder" {}

module "policies" {
    source = "./iam/policies"

    s3_deployment_bucket_arn = var.s3_deployment_bucket_arn
    private_beta_s3_folder   = var.private_beta_s3_folder
}
