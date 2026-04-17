module "mongodb_common" {
  source = "./mongodb-common"
  count  = var.environment == "live" ? 1 : 0
}
