variable "project" {
  type        = string
  description = "The name of the Project"
}

variable "aws_account_id" {
  type        = string
  description = "The AWS Account ID"
}

variable "region" {
  type        = string
  description = "The AWS Region"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "default_tags" {
  type        = map(any)
  description = "Default tag map for application to all taggable resources in the module"
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnet_a" {
  type = string
}

variable "private_subnet_b" {
  type = string
}

variable "private_subnet_c" {
  type = string
}

variable "public_subnet_a" {
  type = string
}

variable "public_subnet_b" {
  type = string
}

variable "public_subnet_c" {
  type = string
}


locals {
  component = "core"
}