terraform {
  required_version = ">= 1.14"

  # TODO Consider if this is the correct provider version
  required_providers {
      aws = {
        configuration_aliases = [ aws.intersite, aws.environment ]
        version = ">= 6.41.0"
      }
      mongodbatlas = {
        source  = "mongodb/mongodbatlas"
        version = "~> 2.10"
      }
  }
}
