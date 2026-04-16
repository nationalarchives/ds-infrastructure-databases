module "mongodb_common" {
  source = "./mongodb-common"
  count  = var.environment == "common" ? 1 : 0
  providers = {
    aws.intersite   = aws.intersite
    aws.environment = aws.environment
  }
}
