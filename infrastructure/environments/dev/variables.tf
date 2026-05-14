# ============================================================================
# VARIABLES - DEV ENVIRONMENT
# ============================================================================

variable "region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "eu-west-1"
}

variable "app_id" {
  description = "Application identifier (AppId) as registered in the Your Organization application catalog. Used as the 3rd segment of the Your Organization naming convention."
  type        = string
}

variable "environment" {
  description = "Environment code following the Your Organization naming convention: c (poc), t (test/sandbox), d (dev), s (stage), p (prod)."
  type        = string

  validation {
    condition     = contains(["c", "t", "d", "s", "p"], var.environment)
    error_message = "environment must be one of: c (poc), t (test/sandbox), d (dev), s (stage), p (prod)."
  }
}

variable "label" {
  description = "Optional label (5th segment of the Your Organization naming convention) to distinguish multiple instances of the same resource type."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Primary domain name for the static website"
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional domain names for the certificate"
  type        = list(string)
  default     = []
}

variable "zone_id" {
  description = "Route 53 hosted zone ID"
  type        = string
}

variable "cloudfront_price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

# ============================================================================
# CLOUDFRONT BEHAVIOR CONFIGURATION
# ============================================================================

variable "default_root_object" {
  description = "Default file to serve (e.g., index.html)"
  type        = string
  default     = "index.html"
}

variable "min_ttl" {
  description = "Minimum cache time to live in seconds"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "Default cache time to live in seconds"
  type        = number
  default     = 3600
}

variable "max_ttl" {
  description = "Maximum cache time to live in seconds"
  type        = number
  default     = 86400
}

# ============================================================================
# SSL/TLS CONFIGURATION
# ============================================================================

variable "minimum_protocol_version" {
  description = "Minimum TLS version for HTTPS connections"
  type        = string
  default     = "TLSv1.2_2021"
}

# ============================================================================
# LOGGING CONFIGURATION
# ============================================================================

variable "log_prefix" {
  description = "Prefix for CloudFront log files in S3"
  type        = string
  default     = "cloudfront/"
}

variable "logs_retention_days" {
  description = "Number of days to retain CloudFront logs before deletion"
  type        = number
  default     = 90
}

# ============================================================================
# ERROR PAGES CONFIGURATION
# ============================================================================

variable "error_404_response_code" {
  description = "HTTP response code to return for 404 errors"
  type        = number
  default     = 200
}

variable "error_404_response_path" {
  description = "Path to the error page for 404 errors"
  type        = string
  default     = "/index.html"
}

variable "error_403_response_code" {
  description = "HTTP response code to return for 403 errors"
  type        = number
  default     = 200
}

variable "error_403_response_path" {
  description = "Path to the error page for 403 errors"
  type        = string
  default     = "/index.html"
}

# ============================================================================
# KMS CONFIGURATION
# ============================================================================

variable "kms_deletion_window_in_days" {
  description = "Number of days before KMS key deletion (7-30 days)"
  type        = number
  default     = 30
}

# ============================================================================
# S3 LIFECYCLE CONFIGURATION
# ============================================================================

variable "noncurrent_version_expiration_days" {
  description = "Number of days to retain old object versions before deletion"
  type        = number
  default     = 30
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Number of days after which incomplete multipart uploads are deleted"
  type        = number
  default     = 7
}

# ============================================================================
# MONITORING CONFIGURATION
# ============================================================================

variable "alert_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
  default     = ""
}

variable "enable_alarms" {
  description = "Enable CloudWatch alarms"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
