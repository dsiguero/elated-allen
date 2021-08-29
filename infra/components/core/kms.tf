resource "aws_kms_key" "core_key" {
  description             = "KMS key for core infrastructure"
  enable_key_rotation     = "true"
  deletion_window_in_days = 10

  tags = {
    Name = "KMS key for core infrastructure"
  }
}

resource "aws_kms_alias" "kms_core_key_alias" {
  name          = "alias/core"
  target_key_id = aws_kms_key.core_key.id
  #target_key_id = "ac9cdef7-b2e6-43c5-8304-73741b75fcba"
}