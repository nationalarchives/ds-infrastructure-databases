### Backup and Restore

1. Run a complete backup of the main server \
```mysqldump --all-databases --master-data > [dump.sql] --user [user_name] --password [password]```
2. Stop replication on secondary server \
```mysqladmin stop-replica``` or ```mysql -e 'STOP REPLICA SQL_THREAD;'```
3. Restore dump to secondary server \
```mysql <[dump.sql]```
4. Restart replication on secondary server\
```mysqladmin start-replica```


