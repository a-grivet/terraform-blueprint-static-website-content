# ============================================================================
# TERRAFORM VARIABLES - PROD ENVIRONMENT
# ============================================================================
# IMPORTANT: Replace placeholder values with your actual configuration
# ============================================================================

# ============================================================================
# PROJECT CONFIGURATION
# ============================================================================
app_id       = "static-website"
environment  = "p"
label        = null           # Optional: add a label to distinguish multiple instances (e.g., "eu-west-3a")
region       = "eu-west-1"

# ============================================================================
# DNS & SSL/TLS CERTIFICATE CONFIGURATION
# ============================================================================
# IMPORTANT: Replace these with your actual Route53 hosted zone details

domain_name = "static-website.your-account-alias-prod.np.your-org-aws.net"  # Your production domain
zone_id     = "ZXXXXXXXXXXXXXXXXXX"                                      # Route53 hosted zone ID

# Optional: Additional domain names (e.g., www subdomain)
subject_alternative_names = []

# ============================================================================
# CLOUDFRONT CONFIGURATION
# ============================================================================
# Using PriceClass_200 for production (better global coverage)

cloudfront_price_class = "PriceClass_200"

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
kms_deletion_window_in_days = 30  # Days before KMS key deletion (7-30)
logs_retention_days         = 365 # Days to keep CloudFront logs (1 year for prod)

# ============================================================================
# S3 LIFECYCLE POLICIES
# ============================================================================
noncurrent_version_expiration_days     = 90 # Days to keep old versions (longer for prod)
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
  Environment = "prod"
  ManagedBy   = "Terraform"
  Owner = "your-team"
}