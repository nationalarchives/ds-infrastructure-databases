output "private_beta_role_arn" {
    value = aws_iam_role.private_beta_postgres_role.arn
}

output "private_beta_role_name" {
    value = aws_iam_role.private_beta_postgres_role.name
}

output "private_beta_instance_profile_name" {
    value = aws_iam_instance_profile.private_beta_postgres_profile.name
}
