# ds-infrastrcuture-databases
Initialising EBS for MySQL and PostgreSQL.
After creating the EBS volume, it will be removed from terraform state to avoid any complications if terraform would change settings of the volume or want to destroy it all together.

The volume could contain data and to avoid data loss no automated delete or change of settings will be done from this repository by running terraform apply.

Any removal of the EBS volume should be done by using the AWS console.
## PostgreSQL EBS
For a short period of time an instance is created to allow formatting the new volume and copying the data files onto after the installation of PostgreSQL on the instance.

To run the installation following pre-requisites are needed:
- Name of secret containing root password, admin user name and password, replication user name and password and network CIDR for external access (Secrets Manager), example /infrastructure/credentials/postgres/maindb - {"root_password":"rootpw","admin_user":"database_admin","admin_password":"adminpw","repl_user":"replication_user","repl_password":"replicapw","listen_nw_cidrs":"10.0.0.0/24, 10.0.0.8/24"} _The cidr blocks in listen_nw_cidrs are added to localhost and private subnet IP ranges for the account._
- Prefix is used for naming volumes _[prefix]_-source and _[prefix]_-replica
