resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/fargate/service/factorial"
  retention_in_days = 90

  tags = {
    Name = "Factorial container Log group"
  }
}

data "template_file" "task_definition" {
  template = file("${path.root}/template/task-definition.json")
  vars = {
    container_name  = "factorial"
    container_image = "${data.terraform_remote_state.core.outputs.image_repository_url}:${var.image_version}"
    container_port  = var.container_port
    aws_region      = var.region
    log_group       = aws_cloudwatch_log_group.ecs_logs.name
  }
}

resource "aws_ecs_task_definition" "taskdef" {
  container_definitions    = data.template_file.task_definition.rendered
  family                   = "factorial-service"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  tags = {
    Name = "Factorial task definition"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name = format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "service"
  )
  cluster                           = data.terraform_remote_state.core.outputs.ecs_cluster_arn
  launch_type                       = "FARGATE"
  task_definition                   = aws_ecs_task_definition.taskdef.arn
  desired_count                     = var.container_desired_count
  health_check_grace_period_seconds = 120

  network_configuration {
    subnets         = data.terraform_remote_state.core.outputs.private_subnets
    security_groups = [aws_security_group.service_sg.id]
  }

  load_balancer {
    container_name   = "factorial"
    container_port   = var.container_port
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }

  depends_on = [aws_alb_listener.alb_listener]

  tags = {
    Name = "Factorial service1"
  }
}