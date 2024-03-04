resource "aws_iam_policy" "mysql_main_deployment_source_access_policy" {
    name        = "mysql-${var.resource_identifier}-deployment-source-access-policy"
    description = "access to deployment source"

    policy = templatefile("${path.root}/templates/s3-deployment-access-policy.json",
        {
            s3_deployment_bucket = var.s3_deployment_bucket
            folder               = var.s3_folder
        }
    )
}

resource "aws_iam_policy" "mysql_main_prime_backup_policy" {
    name        = "mysql-main-prime-backup-policy"
    description = "write access for backups"

    policy = templatefile("${path.root}/templates/database-backup-policy.json",
        {
            s3_deployment_bucket = var.backup_bucket
            folder               = var.backup_folder
        }
    )
}

resource "aws_iam_policy" "attach_ebs_volume_policy" {
    name        = "attach-ebs-volume-policy"
    description = "access to deployment source"

    policy = file("${path.root}/templates/attach-ebs-volume-policy.json")
}

resource "aws_iam_role" "mysql_main_role" {
    name               = "mysql-${var.resource_identifier}-role"
    assume_role_policy = file("${path.root}/templates/assume-role-ec2-policy.json")

    managed_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
        aws_iam_policy.mysql_main_deployment_source_access_policy.arn,
        aws_iam_policy.attach_ebs_volume_policy.arn
    ]

    tags = var.tags
}

resource "aws_iam_instance_profile" "mysql_main_profile" {
    name = "mysql-${var.resource_identifier}-profile"
    role = aws_iam_role.mysql_main_role.name

    tags = var.tags
}
