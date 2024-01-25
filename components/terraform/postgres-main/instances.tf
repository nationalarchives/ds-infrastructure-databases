variable "private_beta_volume_size" {}
variable "private_beta_disable_api_stop" {}
variable "private_beta_disable_api_termination" {}
variable "private_beta_image_id" {}
variable "private_beta_availability_zone" {}
variable "private_beta_ebs_delete_on_termination" {}
variable "private_beta_volume_type" {}
variable "private_beta_description" {}
variable "private_beta_instance_type" {}
variable "private_beta_key_name" {}

module "private_beta_db" {
    source = "instances/private-beta"

    volume_size             = var.private_beta_volume_size
    disable_api_stop        = var.private_beta_disable_api_stop
    disable_api_termination = var.private_beta_disable_api_termination
    image_id                = data.aws_ami.private_beta_db_ami.id
    availability_zone       = var.private_beta_availability_zone
    vpc_security_group_ids  = [
        module.private-beta-sgs.private_beta_sg_id
    ]
    ebs_delete_on_termination = false
    volume_type               = var.private_beta_volume_type
    description               = var.private_beta_description
    iam_instance_profile      = module.roles.private_beta_instance_profile_name
    instance_type             = var.private_beta_instance_type
    key_name                  = var.private_beta_key_name
    tags                      = local.tags
}
