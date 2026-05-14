# ============================================================================
# MODULE: MONITORING - Centralized CloudWatch Monitoring
# ============================================================================
# Dashboard widgets remain local to the blueprint as a JSON template while
# alarm definitions are expressed in HCL for readability and reuse.
# ============================================================================

locals {
  np_segment  = var.environment == "p" ? "" : "np-"
  alarm_base  = "cw-${local.np_segment}${var.app_id}-${var.environment}"

  monitoring_dashboard_body = templatefile("${path.module}/../../monitoring/dashboard.json.tftpl", {
    region                     = var.region
    cloudfront_distribution_id = module.cloudfront.distribution_id
  })

  monitoring_alarm_definitions = {
    error_5xx_rate = {
      alarm_name          = "${local.alarm_base}-cloudfront-5xx-errors"
      alarm_description   = "CRITICAL: High 5xx error rate - site may be down"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 2
      metric_name         = "5xxErrorRate"
      namespace           = "AWS/CloudFront"
      period              = 300
      statistic           = "Average"
      threshold           = 1.0
      treat_missing_data  = "notBreaching"
      dimensions = {
        DistributionId = module.cloudfront.distribution_id
      }
      tags = {
        Name     = "${local.alarm_base}-cloudfront-5xx-errors"
        Severity = "CRITICAL"
      }
    }

    error_4xx_rate = {
      alarm_name          = "${local.alarm_base}-cloudfront-4xx-errors"
      alarm_description   = "CRITICAL: High 4xx error rate - missing content or misconfiguration"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 2
      metric_name         = "4xxErrorRate"
      namespace           = "AWS/CloudFront"
      period              = 300
      statistic           = "Average"
      threshold           = 5.0
      treat_missing_data  = "notBreaching"
      dimensions = {
        DistributionId = module.cloudfront.distribution_id
      }
      tags = {
        Name     = "${local.alarm_base}-cloudfront-4xx-errors"
        Severity = "CRITICAL"
      }
    }

    origin_failures = {
      alarm_name          = "${local.alarm_base}-origin-failures"
      alarm_description   = "CRITICAL: Origin connection failures - S3 access issues"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 1
      metric_name         = "OriginStatus5xx"
      namespace           = "AWS/CloudFront"
      period              = 300
      statistic           = "Sum"
      threshold           = 10
      treat_missing_data  = "notBreaching"
      dimensions = {
        DistributionId = module.cloudfront.distribution_id
      }
      tags = {
        Name     = "${local.alarm_base}-origin-failures"
        Severity = "CRITICAL"
      }
    }

    low_cache_hit_rate = {
      alarm_name          = "${local.alarm_base}-low-cache-hit-rate"
      alarm_description   = "WARNING: Low cache hit rate - performance and cost impact"
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = 3
      metric_name         = "CacheHitRate"
      namespace           = "AWS/CloudFront"
      period              = 300
      statistic           = "Average"
      threshold           = 80
      treat_missing_data  = "notBreaching"
      dimensions = {
        DistributionId = module.cloudfront.distribution_id
      }
      tags = {
        Name     = "${local.alarm_base}-low-cache-hit-rate"
        Severity = "WARNING"
      }
    }

    high_origin_latency = {
      alarm_name          = "${local.alarm_base}-high-origin-latency"
      alarm_description   = "WARNING: High origin latency - slow S3 response times"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 2
      metric_name         = "OriginLatency"
      namespace           = "AWS/CloudFront"
      period              = 300
      statistic           = "Average"
      threshold           = 1000
      treat_missing_data  = "notBreaching"
      dimensions = {
        DistributionId = module.cloudfront.distribution_id
      }
      tags = {
        Name     = "${local.alarm_base}-high-origin-latency"
        Severity = "WARNING"
      }
    }

    traffic_spike = {
      alarm_name          = "${local.alarm_base}-traffic-spike"
      alarm_description   = "WARNING: Unusual traffic spike detected - possible DDoS or viral content"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 1
      threshold           = 200
      treat_missing_data  = "notBreaching"
      metric_queries = [
        {
          id          = "e1"
          expression  = "(m1 / m2) * 100"
          label       = "Traffic Increase Percentage"
          return_data = true
        },
        {
          id = "m1"
          metric = {
            metric_name = "Requests"
            namespace   = "AWS/CloudFront"
            period      = 300
            stat        = "Sum"
            dimensions = {
              DistributionId = module.cloudfront.distribution_id
            }
          }
        },
        {
          id          = "m2"
          return_data = false
          metric = {
            metric_name = "Requests"
            namespace   = "AWS/CloudFront"
            period      = 300
            stat        = "Sum"
            dimensions = {
              DistributionId = module.cloudfront.distribution_id
            }
          }
        }
      ]
      tags = {
        Name     = "${local.alarm_base}-traffic-spike"
        Severity = "WARNING"
      }
    }
  }
}

module "monitoring" {
  source = "git::ssh://your-contact@example.com/a-grivet/terraform-modules-aws-aws.git//modules/monitoring?ref=v1.0.0"

  app_id = var.app_id
  environment  = var.environment
  alert_email  = var.alert_email

  enable_alarms     = var.enable_alarms
  dashboard_body    = local.monitoring_dashboard_body
  alarm_definitions = local.monitoring_alarm_definitions

  tags = merge(
    var.tags,
    { Component = "Monitoring" }
  )

  depends_on = [
    module.cloudfront
  ]
}
