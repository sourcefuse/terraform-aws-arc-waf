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

output "tags_all" {
  value       = aws_wafv2_web_acl.this[*].tags_all
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
}
