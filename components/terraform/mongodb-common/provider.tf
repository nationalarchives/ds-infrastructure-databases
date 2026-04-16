terraform {
  required_version = ">= 1.6"

  # TODO Consider if this is the correct provider version
  required_providers {
      aws = {
        configuration_aliases = [ aws.intersite, aws.environment ]
        version = ">= 5.14.0"
      }
      mongodbatlas = {
        source  = "mongodb/mongodbatlas"
        version = "~> 2.0"
      }
  }
}
