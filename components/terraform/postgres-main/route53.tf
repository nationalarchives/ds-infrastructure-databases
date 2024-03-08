resource "aws_route53_record" "instance" {
    zone_id = var.zone_id
    name    = var.postgres_main_prime_dns
    type    = "CNAME"
    ttl     = 5
    records = [
        aws_instance.postgres_main.private_dns,
    ]
}
