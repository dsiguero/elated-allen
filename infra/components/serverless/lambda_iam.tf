data "aws_iam_policy_document" "lambda_service_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = (format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "lambda-role"
  ))
  assume_role_policy = data.aws_iam_policy_document.lambda_service_policy.json

  tags = {
    "Name" = "Lambda execution role"
  }
}

resource "aws_iam_role_policy_attachment" "basic_execution_role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}