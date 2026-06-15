output "arn" {
  value       = aws_wafv2_web_acl.this[*].arn
  description = "The ARN of the WAF WebACL."
}

output "capacity" {
  value       = aws_wafv2_web_acl.this[*].capacity
  description = "Web ACL capacity units (WCUs) currently being used by this web ACL."
}

output "id" {
  value       = aws_wafv2_web_acl.this[*].id
  description = "The ID of the WAF WebACL."
}

output "ip_set_arn" {
  description = "The IP Set ARN"
  value       = { for k, v in aws_wafv2_ip_set.this : k => v.arn }
}

output "tags_all" {
  value       = aws_wafv2_web_acl.this[*].tags_all
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
}

output "log_group_name" {
  value       = var.logging_config.enabled ? aws_cloudwatch_log_group.waf_logs[0].name : null
  description = "The name of the CloudWatch Log Group for WAF logs"
}

output "log_group_arn" {
  value       = var.logging_config.enabled ? aws_cloudwatch_log_group.waf_logs[0].arn : null
  description = "The ARN of the CloudWatch Log Group for WAF logs"
}

output "logging_configuration_id" {
  value       = var.logging_config.enabled && var.create_web_acl ? aws_wafv2_web_acl_logging_configuration.this[0].id : null
  description = "The ID of the WAF logging configuration"
}

output "log_resource_policy_id" {
  value       = var.logging_config.enabled ? aws_cloudwatch_log_resource_policy.waf_logs[0].id : null
  description = "The ID of the CloudWatch log resource policy"
}
