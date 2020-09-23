provider "aws" {
  #access_key = var.awsAccessKey
  #secret_key = var.awsSecretKey
  shared_credentials_file = var.awsSharedCredentials
  region                  = var.awsRegion
}
