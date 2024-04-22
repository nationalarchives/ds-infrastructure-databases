# project main
# main shared postgres database instance
#
postgres_main_prime   = true
postgres_main_replica = true

postgres_main_disable_api_termination = true
postgres_main_monitoring              = true

postgres_main_instance_type = "t3a.medium"
postgres_main_volume_size   = 40

postgres_main_prime_key_name   = "postgres-main-staging-eu-west-2"
postgres_main_replica_key_name = "postgres-main-staging-eu-west-2"

postgres_main_auto_switch_on  = "true"
postgres_main_auto_switch_off = "true"

postgres_main_prime_dns   = "postgres-main-prime.staging.local"
postgres_main_replica_dns = "postgres-main-replica.staging.local"

