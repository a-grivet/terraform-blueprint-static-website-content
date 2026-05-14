# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-25

### Added
- Initial release of Static Website Blueprint
- Terraform modules for complete static website infrastructure:
  - Backend module for Terraform state management
  - KMS module for S3 bucket encryption
  - S3 Origin module for private content storage
  - ACM module for SSL/TLS certificates
  - CloudFront module for global CDN
  - Route 53 module for DNS management
  - Logs module for CloudFront access logs
- DEV and PROD environment configurations
- GitHub Actions CI/CD workflows:
  - Terraform Plan workflow
  - Terraform Apply workflow
  - Terraform Destroy workflow
  - Terraform Format workflow
- Deployment scripts:
  - deploy.sh for infrastructure deployment
  - deploy-content.sh for website content deployment
- Comprehensive documentation:
  - README.md with architecture diagram
  - CONTRIBUTING.md with development guidelines
  - Inline code documentation
- Security features:
  - KMS Customer Managed Key for S3 encryption
  - CloudFront Origin Access Control (OAC)
  - S3 Public Access Block
  - SSL/TLS enforcement
  - Security headers (HSTS, CSP, etc.)
- Performance optimizations:
  - CloudFront caching configuration
  - Gzip/Brotli compression
  - IPv6 support
  - HTTP/2 and HTTP/3 support
- Cost optimization features:
  - S3 lifecycle policies
  - CloudFront price class selection
  - Log retention policies

### Security
- All S3 buckets are private by default
- KMS encryption for all data at rest
- HTTPS-only access enforced
- Automatic key rotation enabled
- Origin Access Control for CloudFront to S3 access

---

## Template for Future Releases

## [Unreleased]

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security improvements and fixes
