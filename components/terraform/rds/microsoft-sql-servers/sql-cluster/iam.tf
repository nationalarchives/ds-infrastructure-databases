resource "aws_iam_role" "rds_import_export" {
    name = "rds-import-export-role"

    assume_role_policy = file("${path.module}/templates/rds-service-assume-role.json")

    tags = {
        Environment = var.environment
        Name        = "rds-import-export"
    }
}

resource "aws_iam_role_policy" "import_export_access_policy" {
    name = "rds-import-export-s3-access"
    role = aws_iam_role.rds_import_export.id

    policy = templatefile("${path.module}/templates/rds-import-export-s3-access.json", {
        environment = var.environment
    })
}
