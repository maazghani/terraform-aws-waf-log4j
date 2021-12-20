
resource "aws_wafv2_web_acl" "waf_acl" {
  name        = var.name
  description = var.description
  scope       = "REGIONAL"

  # action if none of the rules evaluate
  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 1

    # action to override, set to none to enable blocking
    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"

        # Excluding all these leaves only Log4JRCE

        excluded_rule {
          name = "Host_localhost_HEADER"
        }

        excluded_rule {
          name = "PROPFIND_METHOD"
        }

        excluded_rule {
          name = "ExploitablePaths_URIPATH"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Log4JRCE"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 10

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "waf-metrics"
    sampled_requests_enabled   = false
  }

  tags = merge(
    var.additional_tags,
    {
      Environment   = var.environment
      TerraformPath = element(split("terraform", path.cwd), 1)
    }
  )
}

resource "aws_wafv2_web_acl_association" "alb-association-main" {
  for_each     = toset(var.alb_arns)
  resource_arn = each.value
  web_acl_arn  = aws_wafv2_web_acl.waf_acl.arn
}
