terraform {
    backend "s3" {
        bucket = "ds-terraform-state-eu-west-2-846769538626"
        key    = "ds-infrastructure-databases/terraform.tfstate"
        region = "eu-west-2"
    }
}

provider "aws" {
    region  = "eu-west-2"
    alias   = "environment"
}

provider "aws" {
    alias = "intersite"
    profile = "intersiteadmin"
    region = "eu-west-2"
}

# this provider is used for command line to  suppress input for region
provider "aws" {
    region  = "eu-west-2"
}
