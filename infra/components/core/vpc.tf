module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.6.0"

  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = [var.private_subnet_a, var.private_subnet_b, var.private_subnet_c]
  public_subnets  = [var.public_subnet_a, var.public_subnet_b, var.public_subnet_c]

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "vpc"
  }
}

resource "aws_security_group" "vpc_endpoint_sg" {
  name = format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "vpc-endpoints-sg"
  )
  description = "Allow VPC to talk to VPC endpoints"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = {
    Name = "VPC Endpoints SG"
  }
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "3.6.0"

  vpc_id = module.vpc.vpc_id
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = module.vpc.private_subnets

  endpoints = {
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      tags    = { Name = "ecr-api-vpc-endpoint" }
    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      tags    = { Name = "ecr-dkr-vpc-endpoint" }
    },
    secretsmanager = {
      service = "secretsmanager"
      private_dns_enabled = true
      tags    = { Name = "secretsmanager-vpc-endpoint" }
    },
    logs = {
      service = "logs"
      private_dns_enabled = true
      tags    = { Name = "logs-vpc-endpoint" }
    },
    s3 = {
      service = "s3"
      service_type = "Gateway"
      route_table_ids = module.vpc.private_route_table_ids
      tags    = { Name = "s3-vpc-endpoint" }
    },
  }
}