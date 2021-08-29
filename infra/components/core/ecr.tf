resource "aws_ecr_repository" "image_registry" {
  name = format(
    "%s-%s-%s-%s",
    var.project,
    var.environment,
    local.component,
    "image-registry"
  )

  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.core_key.arn
  }

  image_scanning_configuration {
    scan_on_push = "true"
  }

  tags = {
    Name = "Container image registry"
  }
}
