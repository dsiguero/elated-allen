resource "aws_dynamodb_table" "csv_content" {
  name = format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "csv-data"
  )

  attribute {
    name = "file_key"
    type = "S"
  }

  hash_key       = "file_key"
  read_capacity  = 10
  write_capacity = 5
}
