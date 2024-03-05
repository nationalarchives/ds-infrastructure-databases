postgres_main_prime   = true
postgres_main_replica = false

postgres_main_disable_api_termination = true
postgres_main_monitoring              = true

postgres_main_instance_type = "t3a.small"
postgres_main_volume_size   = 20

postgres_main_ebs_volume_size    = 20
postgres_main_ebs_volume_type    = "gp3"
postgres_main_ebs_final_snapshot = false

postgres_main_prime_key_name   = "postgres-main-dev-eu-west-2"
postgres_main_replica_key_name = "postgres-main-dev-eu-west-2"

postgres_main_auto_switch_on  = "true"
postgres_main_auto_switch_off = "true"

postgres_dns_main_prime   = "postgres-main-prime.dev.local"
postgres_dns_main_replica = "postgres-main-replica.dev.local"

