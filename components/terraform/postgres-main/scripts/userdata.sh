#!/bin/bash

sudo dnf update -y

sudo touch /start-up.log

# mounting process for ebs
echo "$(date '+%Y-%m-%d %T') - check if postgres directory exist" | sudo tee -a /start-up.log > /dev/null
if [ ! -d "/postgres" ]; then
  echo "$(date '+%Y-%m-%d %T') - create postgres directory" | sudo tee -a /start-up.log > /dev/null
  sudo mkdir /postgres
  sudo chown -R postgres:postgres /postgres
else
  echo "$(date '+%Y-%m-%d %T') - postgres directory found" | sudo tee -a /start-up.log > /dev/null
fi

echo "$(date '+%Y-%m-%d %T') - check if EBS is mounted" | sudo tee -a /start-up.log > /dev/null
mounted=$(df -h --type=xfs | grep /postgres)
if [ -z "${mounted}" ]; then
  echo "$(date '+%Y-%m-%d %T') - prepare system for persistent mounting of EBS" | sudo tee -a /start-up.log > /dev/null
  mntDriveID="$(sudo blkid /dev/xvdf | grep -oP 'UUID="(.*?)"' | grep -oP '"(.*?)"' | sed 's/"//g')"
  if [[ -z ${mntDriveID} ]]; then
    sudo echo "$(date '+%Y-%m-%d %T') - error mounting EBS" | sudo tee -a /start-up.log > /dev/null
  else
    echo "$(date '+%Y-%m-%d %T') - set up system for persistent mounting of EBS" | sudo tee -a /start-up.log > /dev/null
    sudo echo "UUID=$mntDriveID  /postgres  xfs  defaults,nofail  0  2" | sudo tee -a /etc/fstab > /dev/null
    echo "$(date '+%Y-%m-%d %T') - mount of EBS" | sudo tee -a /start-up.log > /dev/null
    sudo mount /dev/xvdf /postgres
    echo "$(date '+%Y-%m-%d %T') - sync data to EBS" | sudo tee -a /start-up.log > /dev/null
    sudo rsync -av /var/lib/pgsql/data /postgres
    echo "$(date '+%Y-%m-%d %T') - set up log directory on EBS" | sudo tee -a /start-up.log > /dev/null
    sudo mkdir /postgres/log
    sudo chown -R postgres:postgres /postgres/log
    sudo chmod 0700 /postgres/log
    sudo systemctl start postgresql
  fi
else
  echo "$(date '+%Y-%m-%d %T') - EBS found)" | sudo tee -a /start-up.log > /dev/null
fi
