variable "s3_deployment_bucket_arn" {}
variable "private_beta_s3_folder" {}

resource "aws_iam_policy" "private_beta_s3_deployment_access_policy" {
    name        = "s3-website-deployment-source-access-policy"
    description = "access to source code"

    policy = templatefile("${path.root}/templates/s3-deployment-access-policy.json",
        {
            s3_deployment_source_arn = var.s3_deployment_bucket_arn.value
            folder                   = var.private_beta_s3_folder
        }
    )
}
