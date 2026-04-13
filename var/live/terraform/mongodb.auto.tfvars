environment = "live"
mongo_db_major_version = "8.0"
instance_size  = "M20"
disk_size_gb   = 160
# Note: the provider_disk_iops value below (3000) was chosen arbitrarily because it's the default IOPS
# for the size of cluster we are using at the time of setting this value. A lower value is not possible.
# A higher value may be more appropriate subject to testing. I previously set this to 0 but terraform
# then treats the difference from the default as a change that needs applying every run.
provider_disk_iops = 3000 #If a value is submitted that is lower or equal to the default IOPS value for the cluster tier Atlas ignores the requested value
provider_volume_type = "STANDARD"
auto_scaling_compute_enabled = true
auto_scaling_compute_scale_down_enabled = true
provider_auto_scaling_compute_max_instance_size = "M60"
provider_auto_scaling_compute_min_instance_size = "M20"
cloud_backup = true
backup_reference_hour_of_day = "2"
daily_backup_retention_in_days = "14"
monthly_backup_retention_in_months = "3"
perform_backup_exports = true
mongodb_database_users_secrets_manager_arn = "arn:aws:secretsmanager:eu-west-2:968803923593:secret:mongodb_database_users-emDiGj"