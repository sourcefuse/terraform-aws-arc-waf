output "web_acl_arn" {
  description = "The ARN of the WAF WebACL"
  value       = module.waf.arn
}

output "log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for WAF logs"
  value       = module.waf.log_group_arn
}
