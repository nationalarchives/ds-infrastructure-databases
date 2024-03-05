output "private_beta_instance_dns" {
    value = aws_instance.private_beta_postgres_instance.private_dns
}
