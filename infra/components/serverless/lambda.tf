data "archive_file" "lambda_placeholder" {
  type        = "zip"
  output_path = "${path.root}/placeholder.zip"

  source_dir = "${path.root}/placeholder/"
}

resource "aws_lambda_function" "lambda" {
  description                    = "Retrieves a CSV file from S3 and stores it."
  function_name = (format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "csv-writer"
  ))

  filename                       = "${path.root}/placeholder.zip"
  handler                        = "index.handler"
  memory_size                    = 128
  role                           = aws_iam_role.iam_for_lambda.arn
  runtime                        = "nodejs14.x"
  timeout                        = 30

  # environment {
  #   variables = var.environment_variables
  # }

  tags = {
    "Name" = "csv-writer"
  }
}

resource "aws_lambda_permission" "allow_bucket_execution" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.sinkhole.arn
}
