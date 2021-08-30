resource "aws_alb" "alb" {
  name = format(
    "%s-%s-%s",
    var.project,
    var.environment,
    "alb"
  )
  subnets            = data.terraform_remote_state.core.outputs.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]
  load_balancer_type = "application"

  enable_deletion_protection = true

  tags = {
    Name = "ALB"
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  name        = "${local.component}-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.core.outputs.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    path                = "/health"
    unhealthy_threshold = 2
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "ALB Target group"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }

  tags = {
    Name = "ALB HTTP listener"
  }
}
