variable "project" {
  type        = string
  description = "The name of the Project we are bootstrapping tfscaffold for"
}

variable "aws_account_id" {
  type        = string
  description = "The AWS Account ID into which we are bootstrapping tfscaffold"
}

variable "region" {
  type        = string
  description = "The AWS Region into which we are bootstrapping tfscaffold"
}

variable "environment" {
  type        = string
  description = "The name of the environment for the bootstrapping process; which is always bootstrap"
  default     = "bootstrap"
}

variable "default_tags" {
  type        = map
  description = "Default tag map for application to all taggable resources in the module"
}

locals {
  component = "serverless"
}