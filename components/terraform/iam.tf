variable "s3_deployment_bucket" {}
variable "private_beta_s3_folder" {}

module "policies" {
    source = "./iam/policies"

    s3_deployment_bucket = var.s3_deployment_bucket
    private_beta_s3_folder   = var.private_beta_s3_folder
}
