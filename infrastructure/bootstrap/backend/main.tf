# ============================================================================
# BACKEND BOOTSTRAP WRAPPER - main.tf
# ============================================================================
# This wrapper exists only to bootstrap the remote Terraform backend before the
# environment configuration can use it. The actual backend implementation is
# centralized in terraform-modules-aws.
# ============================================================================

# Configure AWS for the backend bootstrap resources.
provider "aws" {
  region = var.region
}

# Delegate backend creation to the centralized module.
module "backend" {
  source = "git::ssh://your-contact@example.com/a-grivet/terraform-modules-aws-aws.git//modules/backend?ref=v1.0.0"

  prefix = var.prefix
  region = var.region
}
