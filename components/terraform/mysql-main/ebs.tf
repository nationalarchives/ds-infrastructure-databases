resource "aws_ebs_volume" "mysql_main_ebs_prime" {
    availability_zone = var.mysql_main_availability_zone
    encrypted         = true
    final_snapshot    = true
    size              = var.mysql_main_ebs_volume_size

    tags = {
        Name = "mysql-main-ebs-${var.resource_identifier}"
    }
}
