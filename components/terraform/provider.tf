terraform {
    required_version = ">= 1.10"

    required_providers {
        aws = ">= 5.81"
        klayers = {
            version = "~> 1.0.0"
            source  = "ldcorentin/klayer"
        }
    }
}

provider "aws" {
    default_tags {
        tags = {
            Terraform  = "true"
            CostCentre = "53"
            Owner      = "Digital Services"
            Region     = "eu-west-2"
        }
    }
}
