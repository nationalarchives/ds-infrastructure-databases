#!/bin/bash

sudo dnf update -y

sudo touch /var/log/start-up.log

#BASE_DIR="/postgres"
#DATA_DIR="/postgres/data"
#LOG_DIR="/postgres/log"
## mounting process for ebs
#echo "$(date '+%Y-%m-%d %T') - check if postgres directory exist" | sudo tee -a /var/log/start-up.log > /dev/null
#if [ ! -d "$BASE_DIR" ]; then
#  echo "$(date '+%Y-%m-%d %T') - create postgres directory" | sudo tee -a /var/log/start-up.log > /dev/null
#  sudo mkdir $BASE_DIR
#  sudo chown -R postgres:postgres $BASE_DIR
#else
#  echo "$(date '+%Y-%m-%d %T') - postgres directory found" | sudo tee -a /var/log/start-up.log > /dev/null
#fi
#
#echo "$(date '+%Y-%m-%d %T') - check if EBS is mounted" | sudo tee -a /var/log/start-up.log > /dev/null
#mounted=$(df -h --type=xfs | grep $BASE_DIR)
#if [ -z "${mounted}" ]; then
#  echo "$(date '+%Y-%m-%d %T') - prepare system for persistent mounting of EBS" | sudo tee -a /var/log/start-up.log > /dev/null
#  mntDriveID="$(sudo blkid /dev/xvdf | grep -oP 'UUID="(.*?)"' | grep -oP '"(.*?)"' | sed 's/"//g')"
#  if [[ -z ${mntDriveID} ]]; then
#    sudo echo "$(date '+%Y-%m-%d %T') - error mounting EBS" | sudo tee -a /var/log/start-up.log > /dev/null
#  else
#    echo "$(date '+%Y-%m-%d %T') - set up system for persistent mounting of EBS" | sudo tee -a /var/log/start-up.log > /dev/null
#    sudo echo "UUID=$mntDriveID  $BASE_DIR  xfs  defaults,nofail  0  2" | sudo tee -a /etc/fstab > /dev/null
#    echo "$(date '+%Y-%m-%d %T') - mount of EBS" | sudo tee -a /var/log/start-up.log > /dev/null
#    sudo mount /dev/xvdf $BASE_DIR
#    echo "$(date '+%Y-%m-%d %T') - check if data directory exists" | sudo tee -a /var/log/start-up.log > /dev/null
#    if [ ! -d "$DATA_DIR" ]; then
#      echo "$(date '+%Y-%m-%d %T') - stop postgresssql" | sudo tee -a /var/log/start-up.log > /dev/null
#      sudo systemctl stop postgresql
#      echo "$(date '+%Y-%m-%d %T') - sync data to EBS" | sudo tee -a /var/log/start-up.log > /dev/null
#      sudo rsync -av /var/lib/pgsql/data $DATA_DIR
#      echo "$(date '+%Y-%m-%d %T') - remove redundant data directory" | sudo tee -a /var/log/start-up.log > /dev/null
#      sudo rm -R /var/lib/pgsql/data/base
#    else
#      echo "$(date '+%Y-%m-%d %T') - data directory exists" | sudo tee -a /var/log/start-up.log > /dev/null
#    fi
#    echo "$(date '+%Y-%m-%d %T') - check if log directory exists" | sudo tee -a /var/log/start-up.log > /dev/null
#    if [ ! -d "$LOG_DIR" ]; then
#      echo "$(date '+%Y-%m-%d %T') - set up log directory on EBS" | sudo tee -a /var/log/start-up.log > /dev/null
#      sudo mkdir $LOG_DIR
#      sudo chown -R postgres:postgres $LOG_DIR
#      sudo chmod 0700 $LOG_DIR
#    else
#      echo "$(date '+%Y-%m-%d %T') - log directory exists" | sudo tee -a /var/log/start-up.log > /dev/null
#    fi
#    sudo systemctl start postgresql
#  fi
#else
#  echo "$(date '+%Y-%m-%d %T') - EBS found)" | sudo tee -a /var/log/start-up.log > /dev/null
#fi
