variable "mongo_db_major_version" {
    description = "The major version of MongoDB to deploy, e.g. '4.4'"
    type        = string
}

variable "instance_size" {
    description = "The instance size to use for the MongoDB cluster, e.g. 'M20'"
    type        = string
}

variable "disk_size_gb" {
    description = "The disk size in GB to use for the MongoDB cluster, e.g. 128"
    type        = number
}

variable "provider_disk_iops" {
    description = "The number of IOPS to provision for the MongoDB cluster's disk, e.g. 3000. If a value is submitted that is lower or equal to the default IOPS value for the cluster tier Atlas ignores the requested value"
    type        = number
    default     = 3000
}

variable "provider_volume_type" {
    description = "The volume type to use for the MongoDB cluster's disk, e.g. 'STANDARD'"
    type        = string
    default     = "STANDARD"
}

variable "auto_scaling_compute_enabled" {
    description = "Whether to enable auto-scaling of compute for the MongoDB cluster, e.g. true"
    type        = bool
    default     = true
}

variable "auto_scaling_compute_scale_down_enabled" {
    description = "Whether to enable scale down for auto-scaling of compute for the MongoDB cluster, e.g. true"
    type        = bool
    default     = true
}

variable "provider_auto_scaling_compute_max_instance_size" {
    description = "The maximum instance size to use for auto-scaling of compute for the MongoDB cluster, e.g. 'M30'"
    type        = string
    default     = "M60"
}

variable "provider_auto_scaling_compute_min_instance_size" {
    description = "The minimum instance size to use for auto-scaling of compute for the MongoDB cluster, e.g. 'M20'"
    type        = string
    default     = "M20"
}

variable "mongodb_database_users_secrets_manager_arn" {
    description = "The ARN of the AWS Secrets Manager secret that contains the database users for the MongoDB cluster"
    type        = string
}

variable "cloud_backup" {
    description = "Whether to enable cloud backup for the MongoDB cluster, e.g. true"
    type        = bool
    default     = true
}

variable "backup_reference_hour_of_day" {
    description = "When to run Mongo backups"
    type        = string
}
variable "daily_backup_retention_in_days" {
    description = "The number of days to retain daily backups for the MongoDB cluster, e.g. 2"
    type        = number
    default     = 14
}

variable "monthly_backup_retention_in_months" {
    description = "The number of months to retain monthly backups for the MongoDB cluster, e.g. 1"
    type        = number
    default     = 3
}

variable "perform_backup_exports" {
    description = "Whether to perform backup exports for the MongoDB cluster, e.g. false"
    type        = bool
    default     = true
}

module "mongodb" {
  source = "./mongodb"
  account = "ds-${var.environment}"
  owner = "Digital Services"
  cost_centre = 53
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  private_subnet_a_cidr = data.aws_ssm_parameter.private_subnet_a_cidr.value
  private_subnet_b_cidr = data.aws_ssm_parameter.private_subnet_b_cidr.value
  private_subnet_a_id = data.aws_ssm_parameter.private_subnet_a_id.value
  private_subnet_b_id = data.aws_ssm_parameter.private_subnet_b_id.value
  mongodb_org_id = data.aws_ssm_parameter.mongodb_org_id.value
  mongo_db_major_version = var.mongo_db_major_version
  instance_size = var.instance_size
  disk_size_gb = var.disk_size_gb
  provider_disk_iops = var.provider_disk_iops
  provider_volume_type = var.provider_volume_type
  auto_scaling_compute_enabled = var.auto_scaling_compute_enabled
  auto_scaling_compute_scale_down_enabled = var.auto_scaling_compute_scale_down_enabled
  provider_auto_scaling_compute_max_instance_size = var.provider_auto_scaling_compute_max_instance_size
  provider_auto_scaling_compute_min_instance_size = var.provider_auto_scaling_compute_min_instance_size
  mongodb_database_users_secrets_manager_arn = var.mongodb_database_users_secrets_manager_arn
  cloud_backup = var.cloud_backup
  backup_reference_hour_of_day = "2"
  daily_backup_retention_in_days = var.daily_backup_retention_in_days
  monthly_backup_retention_in_months = var.monthly_backup_retention_in_months
  perform_backup_exports = var.perform_backup_exports
  atlas_role_arn = module.iam_roles.atlas_role_arn

  providers = {
    aws.intersite   = aws.intersite
    aws.environment = aws.environment
  }
}