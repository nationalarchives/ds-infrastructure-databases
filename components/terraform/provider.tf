terraform {
  required_version = ">= 1.12"

  # TODO Consider if this is the correct provider version
  required_providers {
      aws = ">= 6.41.0"
      mongodbatlas = {
        source  = "mongodb/mongodbatlas"
        version = "~> 2.10"      }
  }
}
