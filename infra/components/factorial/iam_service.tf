data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "ecs-execution-role"
  )
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}


resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "fargate_task_policydoc" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "fargate_task_policy" {
  name = format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "fargate-task-policy"
  )
  policy = data.aws_iam_policy_document.fargate_task_policydoc.json
}

resource "aws_iam_role" "ecs_task_role" {
  name = format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "ecs-task-role"
  )
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.fargate_task_policy.arn
}