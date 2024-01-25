output "mysql_main_role_arn" {
    value = aws_iam_role.mysql_main_role.arn
}

output "mysql_main_role_name" {
    value = aws_iam_role.mysql_main_role.name
}

output "mysql_main_instance_profile_name" {
    value = aws_iam_instance_profile.mysql_main_profile.name
}
