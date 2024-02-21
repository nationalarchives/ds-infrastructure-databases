resource "aws_ebs_volume" "mysql_main_ebs_prime" {
    count = var.mysql_main_ebs == true ? 1 : 0

    availability_zone = var.mysql_main_availability_zone
    encrypted         = true
    size              = var.mysql_main_ebs_volume_size
    type              = var.mysql_main_ebs_volume_type
    final_snapshot    = var.mysql_main_ebs_final_snapshot

    tags = {
        Name = "mysql-${var.resource_identifier}-ebs"
    }
}
