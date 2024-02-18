mysql_main_prime   = true
mysql_main_replica = true

mysql_main_prime_ebs   = false
mysql_main_replica_ebs = false

mysql_main_disable_api_termination = true
mysql_main_monitoring              = true

mysql_main_instance_type = "t3a.medium"
mysql_main_volume_size   = 40

mysql_main_ebs_volume_size = 40
mysql_main_ebs_volume_type = "gp3"

mysql_main_prime_key_name   = "mysql-main-prime-staging-eu-west-2"
mysql_main_replica_key_name = "mysql-main-replica-staging-eu-west-2"

mysql_main_auto_switch_on  = "true"
mysql_main_auto_switch_off = "true"

mysql_dns_prime   = "mysql-main-prime.staging.local"
mysql_dns_replica = "mysql-main-replica.staging.local"
