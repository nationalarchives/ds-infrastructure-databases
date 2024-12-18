## Setting up MS-SQL RDS Instance \<env>-sql-cluster Database
### Prerequisite
Credentials in Secrets Manager: rds/\<env>-sql-cluster with following structure
```json
{
    "admin": {
        "username": "sqldba",
        "password": "******************"
    }
}
```
Add the ARN of the secret in the variable file ```rds.auto.tfvar``` for the appropriate environment. \

The installation need network information which are read from SSM parameter store.
The values should be set when terraforming the base infrastructure in _ds-infrastructure_.
It is assumed that two separate subnets are available. The parameter names are: \
```/infrastructure/network/base/private_db_subnet_2a_id``` \
```/infrastructure/network/base/private_db_subnet_2b_id```

