resource "aws_instance" "mysql_main" {
    ami                         = var.ami_id
    associate_public_ip_address = false
    availability_zone           = var.mysql_main_availability_zone
    disable_api_termination     = var.disable_api_termination
    iam_instance_profile        = aws_iam_instance_profile.mysql_main_profile.name
    instance_type               = var.instance_type
    key_name                    = var.key_name
    monitoring                  = var.monitoring
    subnet_id                   = var.db_subnet_id
    user_data                   = file("${path.module}/scripts/userdata.sh")

    vpc_security_group_ids = [
        aws_security_group.mysql_main.id,
        var.mysql_ami_build_sg_id,
    ]

    metadata_options {
        http_endpoint          = "enabled"
        http_tokens            = "required"
        instance_metadata_tags = "enabled"
    }

    root_block_device {
        encrypted   = true
        volume_size = var.volume_size
        volume_type = "standard"
        tags = {
            Name = "mysql-${var.resource_identifier}-root"
        }
    }

    tags = merge(var.tags, {
        Name          = "mysql-${var.resource_identifier}"
        AutoSwitchOn  = "true"
        AutoSwitchOff = "true"
    })
}

resource "aws_volume_attachment" "ebs_attachment" {
    device_name = "/dev/xvdf"
    volume_id   = var.attached_ebs_volume_id
    instance_id = aws_instance.mysql_main.id

    skip_destroy = true
}
