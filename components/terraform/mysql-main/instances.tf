resource "aws_instance" "mysql_main" {
    ami                         = var.ami_id
    associate_public_ip_address = false
    availability_zone           = var.mysql_main_availability_zone
    iam_instance_profile        = aws_iam_instance_profile.mysql_main_profile.name
    instance_type               = var.instance_type
    key_name                    = var.key_name
    monitoring                  = var.monitoring
    vpc_security_group_ids      = [
        aws_security_group.mysql_main.id,
        aws_security_group.mysql_main_ami.id,
    ]
    subnet_id = var.db_subnet_a_id

    metadata_options {
        http_endpoint          = "enabled"
        http_tokens            = "required"
        instance_metadata_tags = "enabled"
    }

    root_block_device {
        encrypted   = true
        volume_size = var.volume_size
        volume_type = "standard"
        tags        = {}
    }

    tags = merge(var.tags, {
        Name          = "mysql-main-${var.resource_identifier}"
        AutoSwitchOn  = "true"
        AutoSwitchOff = "true"
    })
}
