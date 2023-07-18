################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.3, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "tags" {
  source = "git::https://github.com/sourcefuse/terraform-aws-refarch-tags.git?ref=1.1.0"

  environment = var.environment
  project     = "terraform-aws-refarch-waf"

  extra_tags = {
    Example = "True"
  }
}

################################################################################
## waf
################################################################################
module "waf" {
  source = "../"

  for_each = { for x in var.waf : x.name => x }

  ## web acl
  create_web_acl            = true
  web_acl_name              = each.value.web_acl_name
  web_acl_description       = each.value.web_acl_description
  web_acl_scope             = each.value.web_acl_scope
  web_acl_default_action    = each.value.web_acl_default_action
  web_acl_visibility_config = each.value.web_acl_visibility_config
  web_acl_rules             = each.value.web_acl_rules

  ## ip set
  create_ip_set          = false
  ip_set_name            = each.value.ip_set_name
  ip_set_description     = each.value.ip_set_description
  ip_set_scope           = each.value.ip_set_scope
  ip_set_address_version = each.value.ip_set_address_version
  ip_set_addresses       = each.value.ip_set_addresses

  tags = module.tags.tags
}
