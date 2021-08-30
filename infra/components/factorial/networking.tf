resource "aws_security_group" "service_sg" {
  name = format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "factorial-service-sg"
  )
  description = "Factorial service SG"
  vpc_id      = data.terraform_remote_state.core.outputs.vpc_id

  dynamic "ingress" {
    for_each = data.terraform_remote_state.core.outputs.public_subnets_cidr_blocks

    content {
      description = "Allow inbound from LB"
      from_port   = var.container_port
      to_port     = var.container_port
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    description     = "Allow outbound HTTPS to VPC Endpoints"
    from_port       = 443
    protocol        = "tcp"
    to_port         = 443
    security_groups = [data.terraform_remote_state.core.outputs.vpc_endpoints_sg_id]
  }

  egress {
    description     = "Allow outbound HTTPS to S3"
    from_port       = 443
    protocol        = "tcp"
    to_port         = 443
    prefix_list_ids = [data.terraform_remote_state.core.outputs.s3_vpce_prefix_list_id]
  }

  tags = {
    Name = "Factorial service SG"
  }
}

resource "aws_security_group" "alb_sg" {
  name = format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "alb-sg"
  )
  description = "ALB SG"
  vpc_id      = data.terraform_remote_state.core.outputs.vpc_id

  ingress {
    description = "Allow inbound from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description     = "Allow to reach the internal port"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.service_sg.id]
  }

  tags = {
    Name = "ALB SG"
  }
}




