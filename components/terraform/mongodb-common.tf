module "mongodb_common" {
  source = "./mongodb-common"
  count  = var.environment == "common" ? 1 : 0
}
