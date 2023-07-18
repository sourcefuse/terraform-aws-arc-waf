################################################################
## shared
################################################################
variable "tags" {
  type        = any
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
}

################################################################
## web acl
################################################################
variable "create_web_acl" {
  type        = bool
  description = "A Boolean indicates whether to create WAF Web ACL or not"
  default     = true
}

variable "web_acl_name" {
  type        = string
  description = "Name of the WAFv2 Web ACL"
}

variable "web_acl_description" {
  type        = string
  description = "Description of the WebACL"
  default     = "Terraform managed Web ACL Configuration"
}

variable "web_acl_scope" {
  type        = string
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL"
  default     = "REGIONAL"
}

variable "web_acl_custom_response_body" {
  type        = any
  description = "Defines custom response bodies that can be referenced by custom_response actions"
  default     = []
}

variable "web_acl_default_action" {
  type        = string
  description = "Action to perform if none of the rules contained in the WebACL match. Options are `allow` or `block`"
}

variable "web_acl_visibility_config" {
  type = object({
    cloudwatch_metrics_enabled = optional(bool, true)
    metric_name                = string
    sampled_requests_enabled   = optional(bool, true)
  })
  description = "Defines and enables Amazon CloudWatch metrics and web request sample collection"
}

variable "web_acl_rules" {
  description = "Rule blocks used to identify the web requests that you want to allow, block, or count"
  type        = any // TODO - improve this if possible. May not be since the types for the different acl's are not similar
  #  type        = object({
  #    name = string
  #    priority = number
  #
  #
  #    statement = object({
  #      rate_based_statement = optional(object({
  #        aggregate_key_type = optional(string, "IP")
  #        limit = number
  #      }), {})
  #
  #      ip_set_reference_statement = optional(object({
  #        arn = string
  #        ip_set_forwarded_ip_config = optional(list(object({
  #
  #        }))
  #      }), {})
  #    })
  #  })
}

################################################################
## ip set
################################################################
variable "create_ip_set" {
  type        = bool
  description = "A Boolean indicates whether to create aws waf ip set or not"
  default     = false
}

variable "ip_set_name" {
  type        = string
  description = "A friendly name of the IP set"
  default     = null
}

variable "ip_set_description" {
  type        = string
  description = "Description for the IP Set configuration"
  default     = "Terraform managed IP Set configuration"
}

variable "ip_set_scope" {
  type        = string
  description = "specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. To work with CloudFront, you must also specify the Region US East"
  default     = "REGIONAL"
}

variable "ip_set_address_version" {
  type        = string
  description = "Specify IPV4 or IPV6.Valid values are IPV4 or IPV6"
  default     = "IPV4"
}

variable "ip_set_addresses" {
  type        = list(string)
  description = "Contains an array of strings that specify one or more IP addresses or blocks of IP addresses in Classless Inter-Domain Routing (CIDR) notation. AWS WAF supports all address ranges for IP versions IPv4 and IPv6"
  default     = []
}
