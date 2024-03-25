#!/bin/bash

sudo touch /var/log/start-up.log

sudo dnf update -y

BASE_DIR="/data"
DATA_DIR="/data/mysql"

# mounting process for ebs
echo "$(date '+%Y-%m-%d %T') - check if mysql directory exist" | sudo tee -a /var/log/start-up.log > /dev/null
if [ ! -d "$BASE_DIR" ]; then
  echo "$(date '+%Y-%m-%d %T') - create mysql directory" | sudo tee -a /var/log/start-up.log > /dev/null
  sudo mkdir $BASE_DIR
  sudo chown -R mysql:mysql $BASE_DIR
else
  echo "$(date '+%Y-%m-%d %T') - mysql directory found" | sudo tee -a /var/log/start-up.log > /dev/null
fi

echo "$(date '+%Y-%m-%d %T') - check if EBS is mounted" | sudo tee -a /var/log/start-up.log > /dev/null
mounted=$(df -h --type=xfs | grep $BASE_DIR)
if [ -z "${mounted}" ]; then
  echo "$(date '+%Y-%m-%d %T') - stop mysql" | sudo tee -a /var/log/start-up.log > /dev/null
  sudo systemctl stop mysqld

  echo "$(date '+%Y-%m-%d %T') - prepare system for persistent mounting of EBS" | sudo tee -a /var/log/start-up.log > /dev/null
  mntDriveID="$(sudo blkid /dev/xvdf | grep -oP 'UUID="(.*?)"' | grep -oP '"(.*?)"' | sed 's/"//g')"
  if [[ -z ${mntDriveID} ]]; then
    sudo echo "$(date '+%Y-%m-%d %T') - error mounting EBS" | sudo tee -a /var/log/start-up.log > /dev/null
  else
    echo "$(date '+%Y-%m-%d %T') - set up system for persistent mounting of EBS" | sudo tee -a /var/log/start-up.log > /dev/null
    sudo echo "UUID=$mntDriveID  $BASE_DIR  xfs  defaults,nofail  0  2" | sudo tee -a /etc/fstab > /dev/null
    echo "$(date '+%Y-%m-%d %T') - mount of EBS" | sudo tee -a /var/log/start-up.log > /dev/null
    sudo mount /dev/xvdf $BASE_DIR
    echo "$(date '+%Y-%m-%d %T') - check if data directory exists" | sudo tee -a /var/log/start-up.log > /dev/null
    if [ ! -d "$DATA_DIR" ]; then
      echo "$(date '+%Y-%m-%d %T') - sync data to EBS" | sudo tee -a /var/log/start-up.log > /dev/null
      sudo rsync -av /var/lib/mysql $BASE_DIR
      echo "$(date '+%Y-%m-%d %T') - remove redundant data directory" | sudo tee -a /var/log/start-up.log > /dev/null
      sudo rm -R /var/lib/mysql
    else
      echo "$(date '+%Y-%m-%d %T') - data directory exists" | sudo tee -a /var/log/start-up.log > /dev/null
    fi

    echo "$(date '+%Y-%m-%d %T') - prepare mysql config" | sudo tee -a /var/log/start-up.log > /dev/null
    sed -i 's|datadir=/var/lib/mysql|datadir=/data/mysql|g' input.txt
    sed -i 's|socket=/var/lib/mysql/mysql.sock|socket=/data/mysql/mysql.sock' input.txt
    sed -i 's|#[client]|[client]' input.txt
    sed -i 's|#socket=/var/lib/mysql/mysql.sock|socket=/data/mysql/mysql.sock' input.txt

    echo "$(date '+%Y-%m-%d %T') - start mysql" | sudo tee -a /var/log/start-up.log > /dev/null
    sudo systemctl start mysqld
  fi
else
  echo "$(date '+%Y-%m-%d %T') - EBS found)" | sudo tee -a /var/log/start-up.log > /dev/null
fi
