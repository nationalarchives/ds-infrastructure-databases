resource "aws_route53_record" "instance" {
    zone_id = var.zone_id
    name    = "mysql-main-${var.resource_identifier}"
    type    = "CNAME"
    ttl     = 5

    set_identifier = "mysql"
    records        = [
        var.mysql_dns,
    ]
}
