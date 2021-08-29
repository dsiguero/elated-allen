data "aws_iam_policy_document" "lambda_service_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "lambda-role"
  )
  assume_role_policy = data.aws_iam_policy_document.lambda_service_policy.json

  tags = {
    "Name" = "Lambda execution role"
  }
}

resource "aws_iam_role_policy_attachment" "basic_execution_role_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "dynamo_put_csv" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:UpdateItem",
      "dynamodb:PutItem",
    ]

    resources = [aws_dynamodb_table.csv_content.arn]
  }
}

resource "aws_iam_policy" "dynamo_put_csv_policy" {
  name = format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "dynamo-csv-put"
  )
  path   = "/"
  policy = data.aws_iam_policy_document.dynamo_put_csv.json
}

resource "aws_iam_role_policy_attachment" "dynamo_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.dynamo_put_csv_policy.arn
}

data "aws_iam_policy_document" "s3_get_csv" {
  statement {
    effect = "Allow"

    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.sinkhole.arn}/*"]
  }
}

resource "aws_iam_policy" "s3_get_csv_policy" {
  name = format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "s3-csv-get"
  )
  path   = "/"
  policy = data.aws_iam_policy_document.s3_get_csv.json
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.s3_get_csv_policy.arn
}