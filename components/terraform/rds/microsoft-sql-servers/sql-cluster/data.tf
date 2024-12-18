data "aws_secretsmanager_secret" "sql_cluster_credentials" {
    arn = var.asm_sql_cluster_arn
}
data "aws_secretsmanager_secret_version" "sql_cluster_credentials" {
    secret_id = data.aws_secretsmanager_secret.sql_cluster_credentials.id
}


data "aws_ssm_parameter" "sql_cluster_vpc_id" {
    name = "/infrastructure/network/base/vpc_id"
}
data "aws_ssm_parameter" "sql_cluster_subnet_a_id" {
    name = "/infrastructure/network/base/private_db_subnet_2a_id"
}
data "aws_ssm_parameter" "sql_cluster_subnet_b_id" {
    name = "/infrastructure/network/base/private_db_subnet_2b_id"
}

