################################################################################
## defaults
################################################################################
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "tags" {
  source = "git::https://github.com/sourcefuse/terraform-aws-refarch-tags.git?ref=1.2.1"

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

  ## web acl
  create_web_acl         = true
  web_acl_name           = "${var.namespace}-${var.environment}-waf-web-acl"
  web_acl_description    = "Terraform managed Web ACL Configuration"
  web_acl_scope          = "REGIONAL"
  web_acl_default_action = "block"
  web_acl_visibility_config = {
    metric_name = "${var.namespace}-${var.environment}-waf-web-acl"
  }
  web_acl_rules = var.web_acl_rules

  ## ip set
  ip_set = [
    {
      name               = "example-ip-set"
      description        = "Example description"
      scope              = "REGIONAL"
      ip_address_version = "IPV4"
      addresses          = []
    }
  ]

  tags = module.tags.tags
}
