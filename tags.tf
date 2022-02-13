data "aws_caller_identity" "id" {}

locals {
  tags = {
    Environment = var.environment
    Designation = "${var.name}-${var.environment}"
    CreatorName = data.aws_caller_identity.id.arn
    Terraform   = true
  }
}
