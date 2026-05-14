# ============================================================================
# MAIN INFRASTRUCTURE CONFIGURATION - PROD ENVIRONMENT
# ============================================================================
# Orchestrates modules to deploy a static website with S3, CloudFront,
# ACM certificate, Route 53, and CloudWatch logging.
# ============================================================================

# ============================================================================
# DATA SOURCES
# ============================================================================

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ============================================================================
# MODULE 1: KMS - Encryption Key for S3
# ============================================================================

module "kms" {
  source = "git::ssh://your-contact@example.com/a-grivet/terraform-modules-aws-aws.git//modules/kms?ref=v1.0.0"

  app_id                  = var.app_id
  environment             = var.environment
  label                   = var.label
  key_name                = "s3-origin"
  description             = "KMS key for S3 origin bucket encryption"
  deletion_window_in_days = var.kms_deletion_window_in_days
  service_principals      = ["cloudfront.amazonaws.com"]
  tags                    = var.tags
}

# ============================================================================
# MODULE 2: LOGS - S3 Bucket for CloudFront Logs
# ============================================================================

module "logs" {
  source = "git::ssh://your-contact@example.com/a-grivet/terraform-modules-aws-aws.git//modules/logs?ref=v1.0.0"

  app_id              = var.app_id
  environment         = var.environment
  label               = var.label
  logs_retention_days = var.logs_retention_days
  tags                = var.tags
}

# ============================================================================
# MODULE 3: ACM - SSL/TLS Certificate (us-east-1)
# ============================================================================

module "acm" {
  source = "git::ssh://your-contact@example.com/a-grivet/terraform-modules-aws-aws.git//modules/acm-cloudfront?ref=v1.0.0"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  app_id                    = var.app_id
  environment               = var.environment
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  zone_id                   = var.zone_id
  tags                      = var.tags
}

# ============================================================================
# MODULE 4: CLOUDFRONT - CDN Distribution
# ============================================================================

module "cloudfront" {
  source = "git::ssh://your-contact@example.com/a-grivet/terraform-modules-aws-aws.git//modules/cloudfront?ref=v1.0.0"

  app_id                         = var.app_id
  environment                    = var.environment
  label                          = var.label
  domain_name                    = var.domain_name
  s3_bucket_id                   = module.s3_origin.bucket_id
  s3_bucket_regional_domain_name = module.s3_origin.bucket_regional_domain_name
  acm_certificate_arn            = module.acm.certificate_arn
  logs_bucket_domain_name        = module.logs.bucket_domain_name
  price_class                    = var.cloudfront_price_class
  default_root_object            = var.default_root_object
  min_ttl                        = var.min_ttl
  default_ttl                    = var.default_ttl
  max_ttl                        = var.max_ttl
  minimum_protocol_version       = var.minimum_protocol_version
  log_prefix                     = var.log_prefix
  error_404_response_code        = var.error_404_response_code
  error_404_response_path        = var.error_404_response_path
  error_403_response_code        = var.error_403_response_code
  error_403_response_path        = var.error_403_response_path
  tags                           = var.tags
}

# ============================================================================
# MODULE 5: S3 ORIGIN - Private Bucket with OAC
# ============================================================================

module "s3_origin" {
  source = "git::ssh://your-contact@example.com/a-grivet/terraform-modules-aws-aws.git//modules/s3-origin?ref=v1.0.0"

  app_id                                 = var.app_id
  environment                            = var.environment
  label                                  = var.label
  kms_key_arn                            = module.kms.key_arn
  cloudfront_distribution_arn            = module.cloudfront.distribution_arn
  noncurrent_version_expiration_days     = var.noncurrent_version_expiration_days
  abort_incomplete_multipart_upload_days = var.abort_incomplete_multipart_upload_days
  tags                                   = var.tags
}

# ============================================================================
# MODULE 6: ROUTE 53 - DNS Records
# ============================================================================

module "route53" {
  source = "git::ssh://your-contact@example.com/a-grivet/terraform-modules-aws-aws.git//modules/route53?ref=v1.0.0"

  zone_id                = var.zone_id
  domain_name            = var.domain_name
  cloudfront_domain_name = module.cloudfront.distribution_domain_name
}

