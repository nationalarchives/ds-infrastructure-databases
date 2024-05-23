# Replication setup
The creation of the AMIs already sets all required values in _postgresql.conf_ and _pg_hba.conf_ to allow the replication to function. \
Also the users are set up in the database itself. \
The following steps need to be done on the servers dependent of function.
## Primary Server
- all settings shouldbe in place
## Replication Server(s)
1. Stop running postgresql service. ```sudo systemctl stop postgresql```
2. Remove the existing data directory ```sudo rm -rv /postgres/data/```
3. Run backup ```sudo pg_basebackup -h [prime_server_ip] -U replicator -X stream -C -S [replication_slot_name] -v -R -W -D /postgres/data/```
4. Change ownership of data ```sudo chown -R postgres:postgres /postgres/data/```
5. Start postgresql service ```sudo systemctl start postgresql```

## Check Replication status
### Primary Server
```select * from pg_stat_replication;```
### Replication Server(s)
```select * from pg_stat_wal_receiver;```

### Replication Slots
To see the used replication slots on the Primary Server use ```SELECT * FROM pg_replication_slots;``` \
To delete a particular slot use ```select pg_drop_replication_slot('[slot_name]');```
