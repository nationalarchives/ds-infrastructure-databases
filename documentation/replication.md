### Backup and Restore

1. Run a complete backup of the main server \
```mysqldump --all-databases --source-data --user [user_name] --password="[password]" > [dump.sql]```
2. Stop replication on secondary server \
```mysqladmin stop-replica``` or ```mysql -e 'STOP REPLICA SQL_THREAD;'```
3. Restore dump to secondary server \
4. ```mysql --user [user] --password="[password"] -e "RESET MASTER;"```
```mysql <[dump.sql]```
4. Restart replication on secondary server\
```mysqladmin start-replica```




