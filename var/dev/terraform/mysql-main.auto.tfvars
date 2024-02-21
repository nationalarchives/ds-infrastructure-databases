mysql_main_prime   = true
mysql_main_replica = false

mysql_main_disable_api_termination = true
mysql_main_monitoring              = true

mysql_main_instance_type = "t3a.small"
mysql_main_volume_size   = 20

mysql_main_ebs_volume_size    = 20
mysql_main_ebs_volume_type    = "gp2"
mysql_main_ebs_final_snapshot = false

mysql_main_prime_key_name   = "mysql-main-dev-eu-west-2"
mysql_main_replica_key_name = "mysql-main-dev-eu-west-2"

mysql_main_auto_switch_on  = "true"
mysql_main_auto_switch_off = "true"

mysql_dns_prime   = "mysql-main-prime.dev.local"
mysql_dns_replica = "mysql-main-replica.dev.local"
