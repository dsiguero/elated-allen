resource "aws_ecs_cluster" "cluster" {
  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.core_key.id

      log_configuration {
        cloud_watch_encryption_enabled = "true"
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_logs.id
        s3_bucket_encryption_enabled   = "false"
      }

      logging = "OVERRIDE"
    }
  }

  name = format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "ecs-cluster"
  )

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/cluster"
  retention_in_days = 90

  tags = {
    Name = "ECS Log group"
  }
}