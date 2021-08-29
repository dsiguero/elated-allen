resource "aws_s3_bucket" "sinkhole" {
  bucket = format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "csv-sinkhole"
  )
  acl = "private"

  force_destroy = false

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    prefix  = ""
    enabled = "true"

    noncurrent_version_transition {
      days          = "30"
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = "60"
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = "90"
    }
  }

  tags = {
    Name = "S3 CSV Sinkhole"
  }
}

resource "aws_s3_bucket_public_access_block" "sinkhole_no_public_access" {
  bucket = aws_s3_bucket.sinkhole.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "bucket_policydoc" {
  statement {
    sid    = "DontAllowNonSecureConnection"
    effect = "Deny"

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.sinkhole.arn,
      "${aws_s3_bucket.sinkhole.arn}/*",
    ]

    principals {
      type = "AWS"
      identifiers = ["*"]
    }

    condition {
      test = "Bool"
      variable = "aws:SecureTransport"

      values = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.sinkhole.id
  policy = data.aws_iam_policy_document.bucket_policydoc.json

  depends_on = [
    aws_s3_bucket_public_access_block.sinkhole_no_public_access,
  ]
}

resource "aws_s3_bucket_notification" "csv_upload" {
  bucket = aws_s3_bucket.sinkhole.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".csv"
  }
}