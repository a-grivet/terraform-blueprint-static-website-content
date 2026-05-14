# ============================================================================
# TERRAFORM BACKEND CONFIGURATION - DEV ENVIRONMENT
# ============================================================================
# Configures remote storage (S3) and native S3 state locking for Terraform.
# Backend values are provided dynamically via GitHub Actions workflow.
# ============================================================================

terraform {
  # ============================================================================
  # TERRAFORM VERSION REQUIREMENT
  # ============================================================================
  required_version = ">= 1.7.4"

  # ============================================================================
  # BACKEND CONFIGURATION - S3
  # ============================================================================
  # Configuration provided dynamically via -backend-config at terraform init.
  # GitHub Actions workflow provides: bucket, key, region, encrypt, use_lockfile
  backend "s3" {
  }

  # ============================================================================
  # REQUIRED PROVIDERS
  # ============================================================================
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ============================================================================
# AWS PROVIDER CONFIGURATION
# ============================================================================

provider "aws" {
  region = var.region

  # Default tags applied to all resources
  default_tags {
    tags = {
      Environment = "dev"
      ManagedBy   = "terraform"
      Project     = var.app_id
      Account     = "dev"
    }
  }
}

# Provider for ACM certificate in us-east-1 (required for CloudFront)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "dev"
      ManagedBy   = "terraform"
      Project     = var.app_id
      Account     = "dev"
    }
  }
}
