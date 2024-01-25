resource "aws_iam_policy" "mysql_main_deployment_source_access_policy" {
    name        = "mysql-main-deployment-source-access-${var.resource_identifier}-policy"
    description = "access to deployment source"

    policy = templatefile("${path.root}/templates/s3-deployment-access-policy.json",
        {
            s3_deployment_bucket = var.s3_deployment_bucket
            folder               = var.s3_folder
        }
    )
}

resource "aws_iam_role" "mysql_main_role" {
    name               = "mysql-main-${var.resource_identifier}-role"
    assume_role_policy = file("${path.root}/templates/assume-role-ec2-policy.json")

    managed_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
        aws_iam_policy.mysql_main_deployment_source_access_policy.arn,
    ]

    tags = var.tags
}

resource "aws_iam_instance_profile" "mysql_main_profile" {
    name = "mysql-main-${var.resource_identifier}-profile"
    role = aws_iam_role.mysql_main_role.name

    tags = var.tags
}
