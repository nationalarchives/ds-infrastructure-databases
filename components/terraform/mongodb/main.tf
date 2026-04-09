variable "account" {}
variable "account_number" {}
variable "owner" {}
variable "cost_centre" {}
variable "environment" {}
variable "vpc_id" {}
variable "private_subnet_a_cidr" {}
variable "private_subnet_b_cidr" {}
variable "private_subnet_a_id" {}
variable "private_subnet_b_id" {}
variable "mongodb_org_id" {}
variable "mongo_db_major_version" {}
variable "instance_size" {}
variable "disk_size_gb" {}
variable "provider_disk_iops" {}
variable "provider_volume_type" {}
variable "auto_scaling_compute_enabled" {}
variable "auto_scaling_compute_scale_down_enabled" {}
variable "provider_auto_scaling_compute_max_instance_size" {}
variable "provider_auto_scaling_compute_min_instance_size" {}
variable "mongodb_database_users_secrets_manager_arn" {}
variable "cloud_backup" {}
variable "backup_reference_hour_of_day" {}
variable "daily_backup_retention_in_days" {}
variable "monthly_backup_retention_in_months" {}
variable "perform_backup_exports" {}
locals {
    kew_developer_network    = data.aws_ssm_parameter.kew_developer_network.value
    kew_app_network          = data.aws_ssm_parameter.kew_app_network.value
    kew_new_test_app_network = data.aws_ssm_parameter.kew_new_test_app_network.value
    kew_new_live_app_network = data.aws_ssm_parameter.kew_new_live_app_network.value
    kew_wvd_network = data.aws_ssm_parameter.kew_wvd_network.value
    london_client_vpn_network = data.aws_ssm_parameter.london_client_vpn_network.value
}

data "aws_secretsmanager_secret" "mongodb_database_user" {
    arn = var.mongodb_database_users_secrets_manager_arn
}

data "aws_secretsmanager_secret_version" "mongodb_users" {
    secret_id = data.aws_secretsmanager_secret.mongodb_database_user.id
}

resource "mongodbatlas_project" "project" {
    name   = "${var.environment}-project"
    org_id = var.mongodb_org_id

    is_collect_database_specifics_statistics_enabled = true
    # https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project#is_data_explorer_enabled
    is_data_explorer_enabled                         = true
    # https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project#is_performance_advisor_enabled
    is_performance_advisor_enabled                   = true
    # https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project#is_realtime_performance_panel_enabled
    is_realtime_performance_panel_enabled            = true
    # https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project#is_schema_advisor_enabled
    is_schema_advisor_enabled                        = true

    lifecycle {
      ignore_changes = [teams]
    }

}

resource "mongodbatlas_team" "platform_team" {
    name   = "Platform Team"
    org_id = var.mongodb_org_id
}

resource "mongodbatlas_team" "developer_team" {
    name   = "Developer Team"
    org_id = var.mongodb_org_id
}

# role permissions documented here: https://www.mongodb.com/docs/atlas/reference/user-roles/#project-roles
resource "mongodbatlas_team_project_assignment" "platform_team" {
    project_id = mongodbatlas_project.project.id
    team_id    = mongodbatlas_team.platform_team.team_id
    role_names = ["GROUP_OWNER", "GROUP_DATA_ACCESS_ADMIN", "GROUP_CLUSTER_MANAGER"]
}

resource "mongodbatlas_team_project_assignment" "developer_team" {
    project_id = mongodbatlas_project.project.id
    team_id    = mongodbatlas_team.developer_team.team_id
    role_names = ["GROUP_OWNER", "GROUP_DATA_ACCESS_ADMIN", "GROUP_CLUSTER_MANAGER"]
}

resource "mongodbatlas_privatelink_endpoint" "endpoint" {
    project_id    = mongodbatlas_project.project.id
    provider_name = "AWS"
    region        = "eu-west-2"
}

resource "aws_security_group" "endpoint_security_group" {
    name        = "mongo-endpoint-sg"
    description = "Security Group controlling access to the Mongo Atlas endpoint"
    vpc_id      = var.vpc_id

    ingress {
        description = "mongo access"
        from_port   = 1024
        to_port     = 1026
        protocol    = "tcp"
        cidr_blocks = [
            var.private_subnet_a_cidr,
            var.private_subnet_b_cidr,
            local.kew_developer_network,
            local.kew_app_network,
            local.kew_new_test_app_network,
            local.kew_new_live_app_network,
            local.london_client_vpn_network,
            local.kew_wvd_network
        ]
    }
}

resource "aws_vpc_endpoint" "mongo_service" {
    vpc_id              = var.vpc_id
    service_name        = mongodbatlas_privatelink_endpoint.endpoint.endpoint_service_name
    vpc_endpoint_type   = "Interface"
    subnet_ids          = [
        var.private_subnet_a_id,
        var.private_subnet_b_id
    ]
    security_group_ids  = [aws_security_group.endpoint_security_group.id]
    private_dns_enabled = false
    # TODO I think we want private_dns_enabled set to true but if this module is applied before the endpoint service
    # has accepted the request, the apply fails. Troubleshoot this message to see if there's a better workaround
    # InvalidParameter: Private DNS can only be enabled after the endpoint connection is accepted by the owner of com.amazonaws.vpce.eu-west-2.vpce-svc-07b70ef6525f16131
    tags                = {
        Name        = "${var.environment}-mongo-endpoint"
        Account     = var.account
        Environment = var.environment
        Owner       = var.owner
        CostCentre  = var.cost_centre
        Terraform   = "true"
    }
}

resource "mongodbatlas_privatelink_endpoint_service" "endpoint_service" {
    project_id          = mongodbatlas_project.project.id
    private_link_id     = mongodbatlas_privatelink_endpoint.endpoint.private_link_id
    endpoint_service_id = aws_vpc_endpoint.mongo_service.id
    provider_name       = "AWS"
}

# The mongodbatlas_cloud_provider_access_setup generates an external ID for the Atlas Project which can then
# be used to constrain cross-account permissions for AWS resources in our dev/staging/live accounts
# The process for setting this up is described (badly) here:
# https://www.mongodb.com/docs/atlas/security/set-up-unified-aws-access/
# And the mongodbatlas provider resources are described (even worse) here, in a page full of errors:
# https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/cloud_provider_access
# NOTE: The below mongodbatlas_cloud_provider_access_setup resource is a dependency for aws_iam_role.mongodbatlas in iam.tf
resource "mongodbatlas_cloud_provider_access_setup" "role" {
   project_id = mongodbatlas_project.project.id
   provider_name = "AWS"
}

# The mongodbatlas_cloud_provider_access_authorization configures Atlas with the ARN of the IAM role(s) it can
# assume in other AWS accounts
# NOTE: The below mongodbatlas_cloud_provider_access_authorization resource depends on aws_iam_role.mongodbatlas in iam.tf
resource "mongodbatlas_cloud_provider_access_authorization" "auth_role" {
   project_id =  mongodbatlas_project.project.id
   role_id    =  mongodbatlas_cloud_provider_access_setup.role.role_id

   aws {
      iam_assumed_role_arn = aws_iam_role.mongodbatlas.arn
   }
}

resource "mongodbatlas_cluster" "cluster" {
    project_id   = mongodbatlas_project.project.id
    name         = "${var.environment}-cluster"
    cluster_type = "REPLICASET"
    replication_specs {
        num_shards = 1
        regions_config {
            region_name     = "EU_WEST_2"
            electable_nodes = 3
            priority        = 7
            read_only_nodes = 0
        }
    }
    cloud_backup                                    = var.cloud_backup
    termination_protection_enabled                  = true
    auto_scaling_disk_gb_enabled                    = true
    auto_scaling_compute_enabled                    = var.auto_scaling_compute_enabled
    auto_scaling_compute_scale_down_enabled         = var.auto_scaling_compute_scale_down_enabled
    provider_auto_scaling_compute_max_instance_size = var.provider_auto_scaling_compute_max_instance_size
    provider_auto_scaling_compute_min_instance_size = var.provider_auto_scaling_compute_min_instance_size
    mongo_db_major_version                          = var.mongo_db_major_version

    //Provider Settings "block"
    provider_name               = "AWS"
    disk_size_gb                = var.disk_size_gb
    # The default value for provider_disk_iops is the same as the cluster tier's Standard IOPS value, as viewable in the Atlas console. It is used in cases where a higher number of IOPS is needed and possible. If a value is submitted that is lower or equal to the default IOPS value for the cluster tier Atlas ignores the requested value and uses the default.
    provider_disk_iops          = var.provider_disk_iops
    provider_volume_type        = var.provider_volume_type
    provider_instance_size_name = var.instance_size

    lifecycle {
        ignore_changes = [
            provider_instance_size_name,
        ]
    }
}

resource "mongodbatlas_cloud_backup_schedule" "cloud_backup_schedule" {
    count                 = var.cloud_backup?1 : 0
    project_id            = mongodbatlas_cluster.cluster.project_id
    cluster_name          = mongodbatlas_cluster.cluster.name
    reference_hour_of_day = var.backup_reference_hour_of_day

    auto_export_enabled = var.perform_backup_exports
    dynamic export {
        for_each = var.perform_backup_exports == true ? [""] : []
        content {
            export_bucket_id = mongodbatlas_cloud_backup_snapshot_export_bucket.mongo_export_bucket.export_bucket_id
            frequency_type = "monthly"
        }
    }
    use_org_and_group_names_in_export_prefix = true
    policy_item_daily {
        frequency_interval = 1
        retention_unit     = "days"
        retention_value    = var.daily_backup_retention_in_days
    }
    policy_item_monthly {
        frequency_interval = 24
        retention_unit     = "months"
        retention_value    = var.monthly_backup_retention_in_months
    }
}

resource "mongodbatlas_cloud_backup_snapshot_export_bucket" "mongo_export_bucket" {
  project_id   = mongodbatlas_cluster.cluster.project_id
  iam_role_id = mongodbatlas_cloud_provider_access_authorization.auth_role.role_id
#TODO: The bucket name below is hardcoded for now, but the value should be coming from
# parameter store set in the repo ds-service-aws-backups
  bucket_name = "ds-${var.environment}-backups"
  cloud_provider = "AWS"
}

resource "mongodbatlas_database_user" "user" {
    for_each = {
        for key, value in nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.mongodb_users.secret_string)) :
        key => value
    } # I believe this syntax will fetch the secret string (a HCL map of users), convert it to a map, and for each one
    # each.value will be the sub-map for each user account. Hence below each.value['username'] will be the username
    # from the sub-map. Does this syntax look correct (lines 131-140) ?
    username           = lookup(each.value, "username", "")
    password           = lookup(each.value, "password", "")
    project_id         = mongodbatlas_project.project.id
    auth_database_name = "admin"


    # Then each user has one or more roles. I believe the block below will create a "roles" block for each
    # item in the "roles" list in the each.value map.
    dynamic "roles" {
        for_each = {
            for key, value in lookup(each.value, "roles", "") : key => value
        }
        content {
            role_name     = roles.value.roleName
            database_name = roles.value.databaseName
        }
    }
}
