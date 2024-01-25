resource "aws_instance" "mysql_main" {
    ami           = var.ami_id
    instance_type = var.instance_type

    metadata_options {
        http_endpoint          = "enabled"
        http_tokens            = "required"
        instance_metadata_tags = "enabled"
    }

    monitoring = var.monitoring

    root_block_device {
        encrypted = true
        volume_size = var.volume_size
        volume_type = "standard"
        tags = {}
    }

    subnet_id = var.db_subnet_a_id

    tags = merge(var.tags, {
        Name = "mysql-mai-${var.resource_identifier}"
    })
}
