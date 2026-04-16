# COMMON Environment
Common is a separate set of resources which are not environment specific (ie with instances in dev, staging and live).

The first use case was to create a MongoDB Organisation, of which there is only one, rather than an organisation in dev, another in staging and so on.

Deploying the Common resources is a prerequisite to deploying the environment specific resources, as the environment specific resources depend on the Common resources. For example, the MongoDB Atlas project in dev, staging and live all depend on the MongoDB Organisation created in Common.

To create the common resources, run the following command from the root of the repository:

```terraform plan -target=module.mongodb-common```

```terraform apply -target=module.mongodb-common```

Do NOT run an untargetted apply of this repo