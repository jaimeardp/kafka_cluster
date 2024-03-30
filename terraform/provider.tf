provider "aws" {
  region              = "us-east-1"
  allowed_account_ids = ["<account_id_aws>"]
  profile = "local_dev"
}