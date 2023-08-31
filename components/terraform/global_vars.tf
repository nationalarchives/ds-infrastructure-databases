locals {
    tags = {
        Terraform   = "true"
        Product     = "website"
        Environment = var.environment
        CostCentre  = "53"
        Owner       = "Digital Services"
        Region      = "eu-west-2"
    }
}

variable "environment" {}

