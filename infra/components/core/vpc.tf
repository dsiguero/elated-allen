module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.6.0"

  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = [var.private_subnet_a, var.private_subnet_b, var.private_subnet_c]
  public_subnets  = [var.public_subnet_a, var.public_subnet_b, var.public_subnet_c]

  tags = {
    Name = "vpc"
  }
}