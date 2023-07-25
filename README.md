# terraform-aws-refarch-waf

## Overview

SourceFuse AWS Reference Architecture (ARC) Terraform module for managing WAF.

## Usage

To see a full example, check out the [main.tf](./example/main.tf) file in the example folder.  

```hcl
module "this" {
  source = "git::https://github.com/sourcefuse/terraform-aws-refarch-waf"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_ip_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_web_acl"></a> [create\_web\_acl](#input\_create\_web\_acl) | A Boolean indicates whether to create WAF Web ACL or not | `bool` | `true` | no |
| <a name="input_ip_set"></a> [ip\_set](#input\_ip\_set) | Configuration for WAFv2 IP Set.<br>      * name: A friendly name of the IP set.<br>      * description: A friendly description of the IP set. Default is "Terraform managed IP Set configuration."<br>      * scope: Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. Default is "REGIONAL."<br>      * ip\_address\_version: Specify IPV4 or IPV6. Valid values are IPV4 or IPV6. Default is "IPV4."<br>      * addresses: Contains an array of strings that specifies zero or more IP addresses or blocks of IP addresses. All addresses must be specified using Classless Inter-Domain Routing (CIDR) notation. WAF supports all IPv4 and IPv6 CIDR ranges except for /0. | <pre>list(object({<br>    name               = string<br>    description        = optional(string, "Terraform managed IP Set configuration")<br>    scope              = optional(string, "REGIONAL")<br>    ip_address_version = optional(string, "IPV4")<br>    addresses          = optional(list(string), [])<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `any` | n/a | yes |
| <a name="input_web_acl_custom_response_body"></a> [web\_acl\_custom\_response\_body](#input\_web\_acl\_custom\_response\_body) | Defines custom response bodies that can be referenced by custom\_response actions | `any` | `[]` | no |
| <a name="input_web_acl_default_action"></a> [web\_acl\_default\_action](#input\_web\_acl\_default\_action) | Action to perform if none of the rules contained in the WebACL match. Options are `allow` or `block` | `string` | n/a | yes |
| <a name="input_web_acl_description"></a> [web\_acl\_description](#input\_web\_acl\_description) | Description of the WebACL | `string` | `"Terraform managed Web ACL Configuration"` | no |
| <a name="input_web_acl_name"></a> [web\_acl\_name](#input\_web\_acl\_name) | Name of the WAFv2 Web ACL | `string` | n/a | yes |
| <a name="input_web_acl_rules"></a> [web\_acl\_rules](#input\_web\_acl\_rules) | Rule blocks used to identify the web requests that you want to allow, block, or count | `any` | n/a | yes |
| <a name="input_web_acl_scope"></a> [web\_acl\_scope](#input\_web\_acl\_scope) | Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL | `string` | `"REGIONAL"` | no |
| <a name="input_web_acl_visibility_config"></a> [web\_acl\_visibility\_config](#input\_web\_acl\_visibility\_config) | Defines and enables Amazon CloudWatch metrics and web request sample collection | <pre>object({<br>    cloudwatch_metrics_enabled = optional(bool, true)<br>    metric_name                = string<br>    sampled_requests_enabled   = optional(bool, true)<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the WAF WebACL. |
| <a name="output_capacity"></a> [capacity](#output\_capacity) | Web ACL capacity units (WCUs) currently being used by this web ACL. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the WAF WebACL. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | Map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Versioning  
This project uses a `.version` file at the root of the repo which the pipeline reads from and does a git tag.  

When you intend to commit to `main`, you will need to increment this version. Once the project is merged,
the pipeline will kick off and tag the latest git commit.  

## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)
- [golint](https://github.com/golang/lint#installation)

### Configurations

- Configure pre-commit hooks
  ```sh
  pre-commit install
  ```

### Tests
- Tests are available in `test` directory
- Configure the dependencies
  ```sh
  cd test/
  go mod init github.com/sourcefuse/terraform-aws-refarch-<module_name>
  go get github.com/gruntwork-io/terratest/modules/terraform
  ```
- Now execute the test  
  ```sh
  go test -timeout  30m
  ```

## Authors

This project is authored by:
- SourceFuse
