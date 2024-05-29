# project main
# main shared mysql database instance
#
mysql_main_prime   = true
mysql_main_replica = true

mysql_main_disable_api_termination = true
mysql_main_monitoring              = true

mysql_main_instance_type = "t3a.large"
mysql_main_volume_size   = 60

mysql_main_key_name   = "mysql-main-live-eu-west-2"

mysql_main_prime_dns   = "mysql-main-prime.live.local"
mysql_main_replica_dns = "mysql-main-replica.live.local"

mysql_main_auto_switch_on  = "true"
mysql_main_auto_switch_off = "true"
