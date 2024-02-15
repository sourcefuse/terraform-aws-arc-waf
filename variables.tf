################################################################
## shared
################################################################
variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  default     = {}
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
  type = list(object({
    key          = string
    content      = string
    content_type = string
  }))
  description = "Defines custom response bodies that can be referenced by custom_response actions"
  default     = []
  validation {
    condition     = length([for custom_response_body in var.web_acl_custom_response_body : true if contains(["TEXT_PLAIN", "TEXT_HTML", "APPLICATION_JSON"], custom_response_body.content_type)]) == length(var.web_acl_custom_response_body)
    error_message = "Make sure that for all objects, the content_type has one of these values: \"TEXT_PLAIN\", \"TEXT_HTML\", \"APPLICATION_JSON\" "
  }
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
  type        = any
  description = "Rule blocks used to identify the web requests that you want to allow, block, or count"
  default     = []
  validation {
    condition     = length([for rule in var.web_acl_rules : true if lookup(rule, "name", null) != null]) == length(var.web_acl_rules)
    error_message = "name is a required attribute"
  }
  validation {
    condition     = length([for rule in var.web_acl_rules : true if lookup(rule, "priority", null) != null]) == length(var.web_acl_rules)
    error_message = "priority is a required attribute"
  }
  validation {
    condition     = length([for rule in var.web_acl_rules : true if lookup(rule, "statement", null) != null]) == length(var.web_acl_rules)
    error_message = "statement is a required attribute"
  }
  validation {
    condition     = length([for rule in var.web_acl_rules : true if lookup(rule, "visibility_config", null) != null]) == length(var.web_acl_rules)
    error_message = "visibility_config is a required attribute"
  }
}

variable "association_resource_arns" {
  type        = list(string)
  description = <<-EOF
    The Amazon Resource Name (ARN) of the resource to associate with the web ACL.
    This must be an ARN of an Application Load Balancer, an Amazon API Gateway stage, or an Amazon Cognito User Pool.
  EOF
  default     = []
}

################################################################
## ip set
################################################################
variable "ip_set" {
  type = list(object({
    name               = string
    description        = optional(string, "Terraform managed IP Set configuration")
    scope              = optional(string, "REGIONAL")
    ip_address_version = optional(string, "IPV4")
    addresses          = optional(list(string), [])
  }))
  description = <<-EOF
    Configuration for WAFv2 IP Set.
      * name: A friendly name of the IP set.
      * description: A friendly description of the IP set. Default is "Terraform managed IP Set configuration."
      * scope: Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. Default is "REGIONAL."
      * ip_address_version: Specify IPV4 or IPV6. Valid values are IPV4 or IPV6. Default is "IPV4."
      * addresses: Contains an array of strings that specifies zero or more IP addresses or blocks of IP addresses. All addresses must be specified using Classless Inter-Domain Routing (CIDR) notation. WAF supports all IPv4 and IPv6 CIDR ranges except for /0.
  EOF
  default     = []
}
