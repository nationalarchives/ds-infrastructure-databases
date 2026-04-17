# Mongodb-common
Common is a separate set of resources which are not environment specific (ie with instances in dev, staging and live).

Teams in MongoDB Atlas are Organisation-specific, rather than Project-specific. For this reason we need to ensure they are created once only and managed by only one state. Live state was chosen for this as it's the one that will likely be created first if a rebuild from scratch is needed.

Deploying the Common resources is a prerequisite to deploying the environment specific resources, as the environment specific resources depend on the Common resources. For example, the MongoDB Atlas project in dev, staging and live all depend on the MongoDB Teams created in Common.

To create the common resources, run the following command from the root of the repository:

```terraform plan -target=module.mongodb-common```

```terraform apply -target=module.mongodb-common```

Do NOT run an untargetted apply of this repo.