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

variable "image_suffix" {
  description = "Name of the container image from ECR"
}

variable "image_version" {
  description = "Version of the container image from ECR"
}

variable "container_port" {
  description = "Port where the dockerized app will run"
  default     = 8080
}

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
variable "container_cpu" {
  description = "The amount of CPU required to run the container"
  default     = 256
}

variable "container_memory" {
  description = "The amount of memory required to run the container"
  default     = 512
}

variable "container_desired_count" {
  description = "The number of instances of the service, running in containers"
  default     = 5
}

locals {
  component = "factorial"
}