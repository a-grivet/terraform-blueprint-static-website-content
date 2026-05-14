#!/bin/bash

# ============================================================================
# WEBSITE CONTENT DEPLOYMENT SCRIPT
# ============================================================================
# This script uploads static website content to S3 and invalidates CloudFront cache.
#
# Usage:
#   ./deploy-content.sh <environment> <content-directory>
#
# Examples:
#   ./deploy-content.sh dev ./dist
#   ./deploy-content.sh prod ./build
# ============================================================================

set -e
set -u

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INFRASTRUCTURE_DIR="$SCRIPT_DIR/infrastructure"

# ============================================================================
# FUNCTIONS
# ============================================================================

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

show_usage() {
    cat << EOF
Usage: $0 <environment> <content-directory>

Arguments:
  environment        dev or prod
  content-directory  Path to directory containing website files

Examples:
  $0 dev ./dist       # Deploy dist folder to dev
  $0 prod ./build     # Deploy build folder to prod

EOF
}

get_aws_resources() {
    local env=$1
    
    print_info "Querying AWS for deployed resources..."
    
    # Get AWS Account ID
    account_id=$(aws sts get-caller-identity --query Account --output text 2>/dev/null)
    if [ -z "$account_id" ]; then
        print_error "Failed to get AWS account ID. Are AWS credentials configured?"
        exit 1
    fi
    
    # Get S3 bucket name using naming convention
    # Format: static-website-{env}-origin-{account_id}
    bucket_name="static-website-${env}-origin-${account_id}"
    
    # Verify bucket exists
    if ! aws s3 ls "s3://${bucket_name}" >/dev/null 2>&1; then
        print_error "S3 bucket not found: ${bucket_name}"
        print_error "Make sure infrastructure is deployed via GitHub Actions first"
        return 1
    fi
    
    # Get CloudFront distribution ID by finding distribution with this S3 bucket as origin
    distribution_id=$(aws cloudfront list-distributions --query \
        "DistributionList.Items[?Origins.Items[?Id=='S3-${bucket_name}']].Id | [0]" \
        --output text 2>/dev/null)
    
    if [ -z "$distribution_id" ] || [ "$distribution_id" == "None" ]; then
        print_error "CloudFront distribution not found for bucket: ${bucket_name}"
        return 1
    fi
    
    # Get domain name from tfvars file
    tfvars_file="$INFRASTRUCTURE_DIR/environments/$env/terraform.tfvars"
    if [ -f "$tfvars_file" ]; then
        website_url="https://$(grep 'domain_name' "$tfvars_file" | cut -d'"' -f2)"
    else
        website_url=""
    fi
    
    # Export variables for main function
    export AWS_BUCKET_NAME="$bucket_name"
    export AWS_DISTRIBUTION_ID="$distribution_id"
    export AWS_WEBSITE_URL="$website_url"
    
    return 0
}

upload_to_s3() {
    local bucket=$1
    local source_dir=$2
    
    print_header "Uploading Content to S3"
    
    print_info "Source: $source_dir"
    print_info "Destination: s3://$bucket/"
    
    # Sync files with proper content types
    aws s3 sync "$source_dir" "s3://$bucket/" \
        --delete \
        --exclude "*.git/*" \
        --exclude ".DS_Store" \
        --cache-control "public, max-age=31536000" \
        --metadata-directive REPLACE
    
    # Set special cache for HTML files (no cache for SPA)
    find "$source_dir" -name "*.html" -type f | while read file; do
        relative_path="${file#$source_dir/}"
        aws s3 cp "$file" "s3://$bucket/$relative_path" \
            --content-type "text/html" \
            --cache-control "no-cache, no-store, must-revalidate" \
            --metadata-directive REPLACE
    done
    
    print_success "Content uploaded to S3"
}

invalidate_cloudfront() {
    local distribution_id=$1
    
    print_header "Invalidating CloudFront Cache"
    
    print_info "Distribution: $distribution_id"
    
    invalidation_output=$(aws cloudfront create-invalidation \
        --distribution-id "$distribution_id" \
        --paths "/*" \
        --output json)
    
    invalidation_id=$(echo "$invalidation_output" | jq -r '.Invalidation.Id')
    
    print_success "Invalidation created: $invalidation_id"
    print_info "CloudFront will update within 5-15 minutes"
}

# ============================================================================
# MAIN SCRIPT
# ============================================================================

main() {
    if [ $# -lt 2 ]; then
        show_usage
        exit 1
    fi
    
    local environment=$1
    local content_dir=$2
    
    # Validate environment
    if [[ ! "$environment" =~ ^(dev|prod)$ ]]; then
        print_error "Invalid environment: $environment"
        exit 1
    fi
    
    # Validate content directory
    if [ ! -d "$content_dir" ]; then
        print_error "Content directory not found: $content_dir"
        exit 1
    fi
    
    # Check for index.html
    if [ ! -f "$content_dir/index.html" ]; then
        print_warning "index.html not found in $content_dir"
        print_warning "Are you sure this is the correct directory?"
        read -p "Continue anyway? (y/n): " confirm
        if [ "$confirm" != "y" ]; then
            print_error "Deployment cancelled"
            exit 1
        fi
    fi
    
    print_header "Static Website Content Deployment"
    print_info "Environment: $environment"
    print_info "Content Directory: $content_dir"
    
    # Get infrastructure outputs from AWS
    print_info "Retrieving infrastructure details from AWS..."
    
    if ! get_aws_resources "$environment"; then
        print_error "Failed to retrieve infrastructure details"
        print_error "Make sure:"
        print_error "  1. AWS credentials are configured"
        print_error "  2. Infrastructure is deployed via GitHub Actions"
        exit 1
    fi
    
    bucket_name="$AWS_BUCKET_NAME"
    distribution_id="$AWS_DISTRIBUTION_ID"
    website_url="$AWS_WEBSITE_URL"
    
    print_success "Infrastructure details retrieved"
    print_info "S3 Bucket: $bucket_name"
    print_info "CloudFront Distribution: $distribution_id"
    
    # Upload content
    upload_to_s3 "$bucket_name" "$content_dir"
    
    # Invalidate CloudFront
    invalidate_cloudfront "$distribution_id"
    
    print_header "Deployment Complete"
    print_success "Content deployed successfully!"
    print_info "Website URL: $website_url"
    print_warning "CloudFront cache invalidation in progress..."
    print_info "Changes will be visible within 5-15 minutes"
}

main "$@"
