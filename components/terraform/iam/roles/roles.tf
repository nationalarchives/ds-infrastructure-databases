variable "mongodbatlas_cloud_provider_access_setup_arn" {}
variable "external_id" {}
# ----------------------------------------------------------------------------------------------------------------------
# Role for MongoDB Atlas to access AWS Resources in our account
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "mongodbatlas" {
    name = "mongodbatlas-role"
    assume_role_policy = templatefile("${path.root}/templates/atlas-trust-policy.json", {
        aws_account = var.mongodbatlas_cloud_provider_access_setup_arn
        external_id = var.external_id
    })
    tags = {
        Name       = "mongodbatlas-role"
        Created_By = "steven.hirschorn@nationalarchives.gov.uk"
    }
}

resource "aws_iam_role_policy_attachment" "mongodbatlas" {
    role       = aws_iam_role.mongodbatlas.name
#TODO: The bucket name below is hardcoded for now, but the value should be coming from
# parameter store set in the repo ds-service-aws-backups - but this won't exist until the objects
# in that repo have been spun up, which can't happen because there will almost certainly be
# dependencies on this repo
    policy_arn = "arn:aws:iam::${var.account_number}:policy/ds-${var.environment}-backups-write"
}

