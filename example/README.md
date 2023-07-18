# terraform-aws-module-waf example

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | git::https://github.com/sourcefuse/terraform-aws-refarch-tags.git | 1.1.0 |
| <a name="module_waf"></a> [waf](#module\_waf) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment resources will belong to. | `string` | `"dev"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_waf"></a> [waf](#input\_waf) | WAF Configuration | <pre>list(object({<br>    ## web acl<br>    create_web_acl         = optional(bool, true)<br>    web_acl_name           = string<br>    web_acl_description    = optional(string, "Terraform managed Web ACL Configuration")<br>    web_acl_scope          = optional(string, "REGIONAL")<br>    web_acl_default_action = string<br>    web_acl_visibility_config = object({<br>      cloudwatch_metrics_enabled = optional(bool, true)<br>      metric_name                = string<br>      sampled_requests_enabled   = optional(bool, true)<br>    })<br>    web_acl_rules = list(any)<br><br>    ## ip sets<br>    create_ip_set          = optional(bool, false)<br>    ip_set_name            = optional(string, "")<br>    ip_set_description     = optional(string, "Terraform managed IP Set configuration")<br>    ip_set_scope           = optional(string, "REGIONAL")<br>    ip_set_address_version = optional(string, "IPV4")<br>    ip_set_addresses       = optional(list(string), [])<br>  }))</pre> | `[]` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
