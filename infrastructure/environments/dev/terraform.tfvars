# ============================================================================
# TERRAFORM VARIABLES - DEV ENVIRONMENT
# ============================================================================
# IMPORTANT: Replace placeholder values with your actual configuration
# ============================================================================

# ============================================================================
# PROJECT CONFIGURATION
# ============================================================================
app_id       = "static-website"
environment  = "d"
label        = null           # Optional: add a label to distinguish multiple instances (e.g., "eu-west-3a")
region       = "eu-west-1"

# ============================================================================
# DNS & SSL/TLS CERTIFICATE CONFIGURATION
# ============================================================================
# IMPORTANT: Replace these with your actual Route53 hosted zone details

domain_name = "static-website.your-account-alias-dev.np.your-org-aws.net"  # Your website domain
zone_id     = "ZXXXXXXXXXXXXXXXXXX"                                    # Route53 hosted zone ID


# ============================================================================
# CLOUDFRONT CONFIGURATION
# ============================================================================
# Price classes:
# - PriceClass_100: USA, Canada, Europe
# - PriceClass_200: USA, Canada, Europe, Asia, Middle East, Africa
# - PriceClass_All: All edge locations

cloudfront_price_class = "PriceClass_100"

# ============================================================================
# CLOUDFRONT CACHE BEHAVIOR
# ============================================================================
min_ttl     = 0      # Minimum cache time in seconds
default_ttl = 3600   # Default cache time in seconds (1 hour)
max_ttl     = 86400  # Maximum cache time in seconds (24 hours)

# ============================================================================
# CLOUDFRONT SETTINGS
# ============================================================================
default_root_object      = "index.html"   # Default file to serve
minimum_protocol_version = "TLSv1.2_2021" # Minimum TLS version
log_prefix               = "cloudfront/"  # CloudFront log prefix in S3

# ============================================================================
# ERROR PAGES CONFIGURATION
# ============================================================================
error_404_response_code = 200           # HTTP code for 404 errors
error_404_response_path = "/index.html" # Page to show for 404 errors
error_403_response_code = 200           # HTTP code for 403 errors
error_403_response_path = "/index.html" # Page to show for 403 errors

# ============================================================================
# SECURITY & LIFECYCLE
# ============================================================================
kms_deletion_window_in_days = 30 # Days before KMS key deletion (7-30)
logs_retention_days         = 90 # Days to keep CloudFront logs

# ============================================================================
# S3 LIFECYCLE POLICIES
# ============================================================================
noncurrent_version_expiration_days     = 30 # Days to keep old versions
abort_incomplete_multipart_upload_days = 7  # Days before cleanup of incomplete uploads

# ============================================================================
# MONITORING CONFIGURATION
# ============================================================================
alert_email   = ""   # Email for CloudWatch alarm notifications (requires confirmation)
enable_alarms = true # Enable CloudWatch alarms

# ============================================================================
# TAGS
# ============================================================================
tags = {
  Project     = "static-website"
  Environment = "dev"
  ManagedBy   = "Terraform"
  Owner = "your-team"
}
