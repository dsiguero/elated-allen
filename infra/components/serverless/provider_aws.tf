# The default AWS provider in the default region
provider "aws" {
  region  = var.region

  # For no reason other than redundant safety
  # we only allow the use of the AWS Account
  # specified in the environment variables.
  # This helps to prevent accidents.
  allowed_account_ids = [
    var.aws_account_id,
  ]

  default_tags {
    tags = merge(var.default_tags, { Component = local.component })
  }
}
