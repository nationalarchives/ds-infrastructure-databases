# Setting up MySQL Database
1. Create an EBS data volume \
Use GitHub Action __EBS Preparation__ and supply the required parameters \
The volume ID will be written to SSM - Parameter Store under ```/infrastructure/databases/[DB type]-[project name]-[function]/volume_id```
2. Create database AMI \
Use GitHub Action __MySQL Base AMI__ and supply the required parameters \
3. Create database instance \
 \
The instance is named ```[DB type]-[project name]-[function]```



## Set up Replication


1. Stop replication \
```STOP REPLICA;```
2. ```RESET MASTER;```
3. ```mysqldump --host mysql-main-prime.[environment].local --user bkup_admin --password="[bkup-admin-password]" --all-databases --lock-all-tables --triggers --routines --events --set-gtid-purged=OFF | mysql --host localhost --user root --password="[root_password]"```
4. Start replication \
```START REPLICA;```


## Replication Issues
First steps to reset replication:
On master database:
```
reset master;
``` 
On replica database:
```
stop replica;
reset replica;
reset master;
start replica;
```



https://www.barryodonovan.com/2013/03/23/recovering-mysql-master-master-replication
SELECT SERVICE_STATE FROM performance_schema.replication_connection_status;
SELECT SERVICE_STATE FROM performance_schema.replication_applier_status;
https://dev.mysql.com/doc/refman/8.4/en/performance-schema-table-reference.html
https://dev.mysql.com/doc/refman/8.4/en/replication-multi-source-monitoring.html
https://dev.mysql.com/doc/refman/8.4/en/show-replica-status.html
https://dev.mysql.com/doc/refman/8.4/en/mysqldump.html
