## Setting up MySQL for Replication
When using GitHub Actions and creating MySQL base AMIs most of the configuration is done when using an AMI to launch a EC2 instance. To set up replication some steps need to be manually. \
If using existing EC2 instances jump to [Main setup manually](#Main-setup-manually)
### Creating an AMI
1. Create an EBS \
Select Action _EBS Preparation_ and run workflow. \
![ebs-preparation.png](documentation%2Fimages%2Febs-preparation.png) \
The naming of the EBS is important to allow the resulting EBS to be connected to the correct EC2 instance. An example for it would be __mysql-services__ indicating that the EBS will be attached to an instance running MySQL server and belongs to the project _services_. \
The project name _services_ will be used later for the AMI build and for deployment of the EC2 instance. \
The selected function will also influence the name of the EBS. As an example, choosing __replica__ and with __mysql-services__ the resulting name of the EBS would be __mysql-services-prime-ebs__.
This makes it easier to identify the connected parts of the installation. \
After a successful run you will have a formatted, empty and ready-to-go EBS.
2. Database AMI
Select Action _MySQL Base AMI_ and run workflow. 
![ami-mysql-action-1.png](documentation%2Fimages%2Fami-mysql-action-1.png) \
Add the project name (without the DB type) and choose the function to line up with the name of the EBS created in step #1 \
__services__ and __replica__ which results in an AMI with the name __mysql-services-replica-[date time]__. \
A successful run will create a deployable AMI which has the rudimental settings in place ready to be deployed.
3. Deployment of AMI
The deployment of the EC2 instance will be done with terraform.
### Main setup manually
1. Attach EBS to EC2 instance \
Data should be stored on an EBS drive attached to the EC2 instance allowing the replacement of the instance without deleting the data. \
``` df | grep "/data" ``` should show you something similar to ``` /dev/nvme1n1      20905984 1503004  19402980   8% /data ``` if EBS has been attached. \
If this isn't the case you need to mount the EBS drive by following the steps beneath \
1.1 If the directory ``` /data ``` doesn't exist create with command ``` sudo mkdir /data ``` \
1.2 Mount the EBS with command 
2. Configure MySQL - /etc/my.cnf
```
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
server-id=101
user=mysql
gtid_mode=ON
enforce-gtid-consistency=ON

#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove the leading "# " to disable binary logging
# Binary logging captures changes between backups and is enabled by
# default. It's default setting is log_bin=binlog
# disable_log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
#
# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password

datadir=/data/mysql
socket=/data/mysql.sock

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

[mysqldump]
routines=true

#[client]
socket=/data/mysql.sock
```
