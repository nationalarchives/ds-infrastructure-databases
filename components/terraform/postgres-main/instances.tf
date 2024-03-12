resource "aws_instance" "postgres_main" {
    ami                         = var.ami_id
    associate_public_ip_address = false
    availability_zone           = var.availability_zone
    disable_api_termination     = var.disable_api_termination
    iam_instance_profile        = aws_iam_instance_profile.postgres_main_profile.name
    instance_type               = var.instance_type
    key_name                    = var.key_name
    monitoring                  = var.monitoring
    user_data                   = file("${path.module}/scripts/userdata.sh")

    vpc_security_group_ids = [
        aws_security_group.postgres_main.id,
        var.postgres_ami_build_sg_id,
    ]
    subnet_id = var.db_subnet_id


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
        Name          = "postgres-${var.resource_identifier}"
        AutoSwitchOn  = "true"
        AutoSwitchOff = "true"
    })
}

resource "aws_volume_attachment" "ebs_attachment" {
    device_name = "/dev/xvdf"
    volume_id   = var.attached_ebs_volume_id
    instance_id = aws_instance.postgres_main.id

    skip_destroy = true
}
