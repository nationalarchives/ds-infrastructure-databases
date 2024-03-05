variable "private_beta_s3_deployment_access_policy_arn" {}
variable "tags" {}

resource "aws_iam_role" "private_beta_postgres_role" {
    name               = "private-beta-postgres-role"
    assume_role_policy = file("${path.root}/templates/assume-role-ec2-policy.json")

    managed_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
        var.private_beta_s3_deployment_access_policy_arn,
    ]

    tags = var.tags
}

resource "aws_iam_instance_profile" "private_beta_postgres_profile" {
    name = "private_beta_postgres_profile"
    role = aws_iam_role.private_beta_postgres_role.name

    tags = var.tags
}
