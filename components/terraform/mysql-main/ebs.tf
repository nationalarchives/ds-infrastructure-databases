resource "aws_ebs_volume" "mysql_main_ebs_prime" {
    count = var.mysql_main_ebs ? 1 : 0

    availability_zone = var.mysql_main_availability_zone
    final_snapshot    = true
    size              = var.mysql_main_ebs_volume_size

    tags = {
        Name = "mysql-main-ebs-${var.resource_identifier}"
    }
}
