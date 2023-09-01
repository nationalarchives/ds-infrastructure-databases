variable "volume_size" {}
variable "disable_api_stop" {}
variable "disable_api_termination" {}
variable "image_id" {}
variable "availability_zone" {}
variable "vpc_security_group_ids" {}
variable "ebs_delete_on_termination" {}
variable "volume_type" {}
variable "description" {}
variable "iam_instance_profile" {}
variable "instance_type" {}
variable "key_name" {}
variable "tags" {}

resource "aws_launch_template" "private_beta_db_launch_tpl" {
    name = "private-beta-db-launch-tpl"

    block_device_mappings {
        device_name = "/dev/sdf"

        ebs {
            delete_on_termination = var.ebs_delete_on_termination
            encrypted             = true
            volume_size           = var.volume_size
            volume_type           = var.volume_type
        }
    }

    disable_api_stop        = var.disable_api_stop
    disable_api_termination = var.disable_api_termination

    description = var.description

    iam_instance_profile {
        name = var.iam_instance_profile
    }

    image_id = var.image_id

    instance_initiated_shutdown_behavior = "stop"

    instance_type = var.instance_type

    key_name = var.key_name

    metadata_options {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 1
        instance_metadata_tags      = "enabled"
    }

    monitoring {
        enabled = true
    }

    network_interfaces {
        associate_public_ip_address = false
    }

    placement {
        availability_zone = var.availability_zone
    }

    vpc_security_group_ids = var.vpc_security_group_ids

    tag_specifications {
        resource_type = "instance"

        tags = merge(var.tags, {
            Name = "private-beta-db"
        })
    }

    user_data = filebase64("${path.module}/example.sh")
}
