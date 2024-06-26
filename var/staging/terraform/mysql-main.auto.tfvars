mysql_main_prime   = true
mysql_main_replica = true

mysql_main_disable_api_termination = true
mysql_main_monitoring              = true

mysql_main_instance_type = "t3a.medium"
mysql_main_volume_size   = 40

mysql_main_key_name   = "mysql-main-staging-eu-west-2"

mysql_main_prime_dns   = "mysql-main-prime.staging.local"
mysql_main_replica_dns = "mysql-main-replica.staging.local"

mysql_main_auto_switch_on  = "true"
mysql_main_auto_switch_off = "true"
