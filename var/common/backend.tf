terraform {
    backend "s3" {
# The state should probably be stored in a bucket in Intersite:
# This makes Intersite a prerequisite for this module
# Should the bucket be solely for this module? If we create a dedicated bucket it will be more
# clearly associated with this module. If we reuse an existing terraform state bucket, it might
# be
        bucket = "ds-terraform-state-eu-west-2-968803923593"
        key    = "ds-infrastructure-databases_common/terraform.tfstate"
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
