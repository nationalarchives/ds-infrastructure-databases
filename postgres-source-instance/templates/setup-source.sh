#!/bin/bash

ROOT_DIR="/postgres"
DATA_DIR="/postgres/data"
LOG_DIR="/postgres/log"

# Configure PostgreSQL for replication
# the directories are specific for the version of postgres and linux 2 from AWS
sudo sed -i "s|#data_directory = 'ConfigDir'|data_directory = '$DATA_DIR'|" /var/lib/pgsql/data/postgresql.conf
sudo sed -i "s|#log_directory = 'log'|log_directory = '$LOG_DIR'|" /var/lib/pgsql/data/postgresql.conf
sudo sed -i "s/#wal_level = replica/wal_level = logical/" /var/lib/pgsql/data/postgresql.conf
sudo sed -i "s/#wal_log_hints = off/wal_log_hints = on/" /var/lib/pgsql/data/postgresql.conf
sudo sed -i "s/#max_replication_slots = 10/max_replication_slots = 10/" /var/lib/pgsql/data/postgresql.conf
sudo sed -i "s/#max_wal_senders = 10/max_wal_senders = 10/" /var/lib/pgsql/data/postgresql.conf

# Set up access to postgres
#sudo sed -i "/# TYPE/a host replication {{rep_user}} 10.128.212.0/23 trust\n" /var/lib/pgsql/data/pg_hba.conf
sudo sed -i "/# TYPE/a host all all 10.128.210.0/23 md5\n" /var/lib/pgsql/data/pg_hba.conf
sudo sed -i "/# TYPE/a host all all 10.128.224.0/22 md5\n" /var/lib/pgsql/data/pg_hba.conf
sudo sed -i "/# TYPE/a host all replica_admin 10.128.212.0/23 md5\n" /var/lib/pgsql/data/pg_hba.conf
sudo sed -i "/# TYPE/a local all postgres md5\n" /var/lib/pgsql/data/pg_hba.conf

cat << EOF > ~/postgres-setup.txt
[status]
finished = true
EOF
