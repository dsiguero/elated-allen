resource "aws_kms_key" "s3" {
  description             = "tfscaffold Bootstrap S3 Bucket"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = data.aws_iam_policy_document.kms_key_s3.json

  tags = {
    Name        = "KMS for S3 remote state bucket"
  }
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/s3-remote-state"
  target_key_id = aws_kms_key.s3.key_id
}