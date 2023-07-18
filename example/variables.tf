################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Name of the environment resources will belong to."
}

################################################################################
## waf
################################################################################
variable "waf" {
  type = list(object({
    ## web acl
    create_web_acl         = optional(bool, true)
    web_acl_name           = string
    web_acl_description    = optional(string, "Terraform managed Web ACL Configuration")
    web_acl_scope          = optional(string, "REGIONAL")
    web_acl_default_action = string
    web_acl_visibility_config = object({
      cloudwatch_metrics_enabled = optional(bool, true)
      metric_name                = string
      sampled_requests_enabled   = optional(bool, true)
    })
    web_acl_rules = list(any)

    ## ip sets
    create_ip_set          = optional(bool, false)
    ip_set_name            = optional(string, "")
    ip_set_description     = optional(string, "Terraform managed IP Set configuration")
    ip_set_scope           = optional(string, "REGIONAL")
    ip_set_address_version = optional(string, "IPV4")
    ip_set_addresses       = optional(list(string), [])
  }))
  description = "WAF Configuration"
  default     = []
}
