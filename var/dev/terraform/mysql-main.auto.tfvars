mysql_main_prime   = true
mysql_main_replica = false

mysql_main_prime_ebs   = false
mysql_main_replica_ebs = false

mysql_main_disable_api_termination = true
monitoring                         = true

mysql_main_instance_type = "t3a.small"
mysql_main_volume_size   = 20

mysql_main_ebs_volume_size = 20
mysql_main_ebs_volume_type = "gp3"

mysql_main_prime_key_name   = "mysql-main-dev-eu-west-2"
mysql_main_replica_key_name = "mysql-main-dev-eu-west-2"

mysql_dns = "mysql-main.dev.local"
