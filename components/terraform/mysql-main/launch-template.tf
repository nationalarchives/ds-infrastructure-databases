resource "aws_launch_template" "mysql_main" {
    name = "mysql-main"

    iam_instance_profile {
        arn = aws_iam_instance_profile.mysql_main_profile.arn
    }

    image_id               = var.ami_id
    instance_type          = var.instance_type
    key_name               = var.key_name
    update_default_version = true

    vpc_security_group_ids = [
        aws_security_group.mysql_main.id,
    ]

    user_data = base64encode(templatefile("${path.module}/scripts/userdata.sh", {
        mount_target = aws_efs_file_system.website.dns_name
        mount_dir    = var.efs_mount_dir
    }))

    block_device_mappings {
        device_name = "/dev/xvda"

        ebs {
            volume_size = var.volume_size
            encrypted   = true
        }
    }
}
