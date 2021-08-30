data "terraform_remote_state" "core" {
  backend = "s3"

  config = {
    bucket = "${var.project}-tfscaffold-${var.aws_account_id}-${var.region}"

    key = format(
      "%s/%s/%s/%s/%s.tfstate",
      var.project,
      var.aws_account_id,
      var.region,
      var.environment,
      "core"
    )

    region = var.region
  }
}