# project main
# main shared postgres database instance
#
postgres_main_prime   = true
postgres_main_replica = true

postgres_main_disable_api_termination = true
postgres_main_monitoring              = true

postgres_main_instance_type = "t3a.large"
postgres_main_volume_size   = 100

postgres_main_prime_key_name   = "postgres-main-live-eu-west-2"
postgres_main_replica_key_name = "postgres-main-live-eu-west-2"

postgres_main_auto_switch_on  = "false"
postgres_main_auto_switch_off = "false"

postgres_main_prime_dns   = "postgres-main-prime.live.local"
postgres_main_replica_dns = "postgres-main-replica.live.local"

