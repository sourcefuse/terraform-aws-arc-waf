################################################################
## defaults
################################################################
terraform {
  required_version = ">= 1.3, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

################################################################
## web acl
################################################################
## web acl
resource "aws_wafv2_web_acl" "this" {
  count = var.create_web_acl == true ? 1 : 0

  name        = var.web_acl_name
  description = var.web_acl_description
  scope       = var.web_acl_scope

  default_action {
    dynamic "allow" {
      for_each = var.web_acl_default_action == "allow" ? [1] : []
      content {}
    }

    dynamic "block" {
      for_each = var.web_acl_default_action == "block" ? [1] : []
      content {}
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.web_acl_visibility_config.cloudwatch_metrics_enabled
    metric_name                = var.web_acl_visibility_config.metric_name
    sampled_requests_enabled   = var.web_acl_visibility_config.sampled_requests_enabled
  }

  dynamic "custom_response_body" {
    for_each = length(var.web_acl_custom_response_body) > 0 ? var.web_acl_custom_response_body : []

    content {
      key          = lookup(custom_response_body.value, "key", null)
      content      = lookup(custom_response_body.value, "content", null)
      content_type = lookup(custom_response_body.value, "content_type", null)
    }
  }

  dynamic "rule" {
    for_each = var.web_acl_rules

    content {
      name     = lookup(rule.value, "name", null)
      priority = lookup(rule.value, "priority", null)

      dynamic "visibility_config" {
        for_each = lookup(rule.value, "visibility_config", [])

        content {
          cloudwatch_metrics_enabled = try(visibility_config.value.cloudwatch_metrics_enabled, true)
          metric_name                = visibility_config.value.metric_name
          sampled_requests_enabled   = try(visibility_config.value.sampled_requests_enabled, true)
        }
      }

      dynamic "action" {
        for_each = lookup(rule.value, "action", [])

        content {
          dynamic "allow" {
            for_each = lookup(action.value, "allow", [])
            content {}
          }

          dynamic "block" {
            for_each = lookup(action.value, "block", [])

            content {
              dynamic "custom_response" {
                for_each = lookup(block.value, "custom_response", [])

                content {
                  response_code = lookup(custom_response.value, "response_code", null)
                }
              }
            }
          }

          dynamic "count" {
            for_each = lookup(action.value, "count", [])
            content {}
          }

          dynamic "captcha" {
            for_each = lookup(action.value, "captcha", [])
            content {}
          }
        }

      }

      dynamic "override_action" {
        for_each = lookup(rule.value, "override_action", [])

        content {
          dynamic "none" {
            for_each = lookup(override_action.value, "none", [])

            content {}
          }
          dynamic "count" {
            for_each = lookup(override_action.value, "count", [])

            content {}
          }
        }
      }

      dynamic "rule_label" {
        for_each = lookup(rule.value, "rule_label", [])

        content {
          name = lookup(rule_label.value, "name", null)
        }
      }

      dynamic "statement" {
        for_each = lookup(rule.value, "statement", [])

        content {
          dynamic "rate_based_statement" {
            for_each = lookup(statement.value, "rate_based_statement", [])

            content {
              aggregate_key_type = lookup(rate_based_statement.value, "aggregate_key_type", null)
              limit              = lookup(rate_based_statement.value, "limit", {})

              dynamic "scope_down_statement" {
                for_each = lookup(rate_based_statement.value, "scope_down_statement", [])

                content {
                  dynamic "not_statement" {
                    for_each = lookup(scope_down_statement.value, "not_statement", [])

                    content {
                      dynamic "statement" {
                        for_each = lookup(not_statement.value, "statement", [])

                        content {
                          dynamic "ip_set_reference_statement" {
                            for_each = lookup(statement.value, "ip_set_reference_statement", [])

                            content {
                              arn = lookup(ip_set_reference_statement.value, "arn", null)

                              dynamic "ip_set_forwarded_ip_config" {
                                for_each = lookup(ip_set_reference_statement.value, "ip_set_forwarded_ip_config", [])

                                content {
                                  fallback_behavior = lookup(ip_set_forwarded_ip_config.value, "fallback_behavior", null)
                                  header_name       = lookup(ip_set_forwarded_ip_config.value, "header_name", null)
                                  position          = lookup(ip_set_forwarded_ip_config.value, "position", null)
                                }
                              }
                            }
                          }

                          dynamic "byte_match_statement" {
                            for_each = lookup(statement.value, "byte_match_statement", [])

                            content {
                              positional_constraint = lookup(byte_match_statement.value, "positional_constraint", null)
                              search_string         = lookup(byte_match_statement.value, "search_string", null)

                              dynamic "field_to_match" {
                                for_each = lookup(byte_match_statement.value, "field_to_match", [])

                                content {
                                  dynamic "uri_path" {
                                    for_each = lookup(field_to_match.value, "uri_path", [])

                                    content {}
                                  }
                                }
                              }

                              dynamic "text_transformation" {
                                for_each = lookup(byte_match_statement.value, "text_transformation", [])

                                content {
                                  priority = lookup(text_transformation.value, "priority", null)
                                  type     = lookup(text_transformation.value, "type", null)
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          dynamic "ip_set_reference_statement" {
            for_each = lookup(statement.value, "ip_set_reference_statement", [])

            content {
              arn = lookup(ip_set_reference_statement.value, "arn", null)

              dynamic "ip_set_forwarded_ip_config" {
                for_each = lookup(ip_set_reference_statement.value, "ip_set_forwarded_ip_config", [])

                content {
                  fallback_behavior = lookup(ip_set_forwarded_ip_config.value, "fallback_behavior", null)
                  header_name       = lookup(ip_set_forwarded_ip_config.value, "header_name", null)
                  position          = lookup(ip_set_forwarded_ip_config.value, "position", null)
                }
              }
            }
          }

          dynamic "and_statement" {
            for_each = lookup(statement.value, "and_statement", [])

            content {
              dynamic "statement" {
                for_each = lookup(and_statement.value, "statement", [])

                content {
                  dynamic "ip_set_reference_statement" {
                    for_each = lookup(statement.value, "ip_set_reference_statement", [])

                    content {
                      arn = lookup(ip_set_reference_statement.value, "arn", null)

                      dynamic "ip_set_forwarded_ip_config" {
                        for_each = lookup(ip_set_reference_statement.value, "ip_set_forwarded_ip_config", [])

                        content {
                          fallback_behavior = lookup(ip_set_forwarded_ip_config.value, "fallback_behavior", null)
                          header_name       = lookup(ip_set_forwarded_ip_config.value, "header_name", null)
                          position          = lookup(ip_set_forwarded_ip_config.value, "position", null)
                        }
                      }
                    }
                  }

                  dynamic "not_statement" {
                    for_each = lookup(statement.value, "not_statement", [])

                    content {
                      dynamic "statement" {
                        for_each = lookup(not_statement.value, "statement", [])

                        content {
                          dynamic "ip_set_reference_statement" {
                            for_each = lookup(statement.value, "ip_set_reference_statement", [])

                            content {
                              arn = lookup(ip_set_reference_statement.value, "arn", null)

                              dynamic "ip_set_forwarded_ip_config" {
                                for_each = lookup(ip_set_reference_statement.value, "ip_set_forwarded_ip_config", [])

                                content {
                                  fallback_behavior = lookup(ip_set_forwarded_ip_config.value, "fallback_behavior", null)
                                  header_name       = lookup(ip_set_forwarded_ip_config.value, "header_name", null)
                                  position          = lookup(ip_set_forwarded_ip_config.value, "position", null)
                                }
                              }
                            }
                          }

                          dynamic "regex_match_statement" {
                            for_each = lookup(statement.value, "regex_match_statement", [])

                            content {
                              regex_string = lookup(regex_match_statement.value, "regex_string", null)

                              dynamic "field_to_match" {
                                for_each = lookup(regex_match_statement.value, "field_to_match", [])

                                content {
                                  dynamic "single_header" {
                                    for_each = lookup(field_to_match.value, "single_header", [])

                                    content {
                                      name = lookup(single_header.value, "name", null)
                                    }
                                  }
                                }
                              }

                              dynamic "text_transformation" {
                                for_each = lookup(regex_match_statement.value, "text_transformation", [])

                                content {
                                  priority = lookup(text_transformation.value, "priority", null)
                                  type     = lookup(text_transformation.value, "type", null)
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }

                  dynamic "label_match_statement" {
                    for_each = lookup(statement.value, "label_match_statement", [])

                    content {
                      scope = label_match_statement.value.scope
                      key   = label_match_statement.value.key
                    }
                  }

                  dynamic "xss_match_statement" {
                    for_each = lookup(statement.value, "xss_match_statement", [])

                    content {
                      dynamic "field_to_match" {
                        for_each = lookup(xss_match_statement.value, "field_to_match", [])

                        content {
                          dynamic "body" {
                            for_each = lookup(field_to_match.value, "body", [])

                            content {
                              oversize_handling = body.value.oversize_handling
                            }
                          }

                          dynamic "uri_path" {
                            for_each = lookup(field_to_match.value, "uri_path", [])

                            content {}
                          }

                          dynamic "query_string" {
                            for_each = lookup(field_to_match.value, "query_string", [])

                            content {}
                          }

                          dynamic "single_header" {
                            for_each = lookup(field_to_match.value, "single_header", [])

                            content {
                              name = lookup(single_header.value, "name", null)
                            }
                          }
                        }
                      }

                      dynamic "text_transformation" {
                        for_each = lookup(xss_match_statement.value, "text_transformation", [])

                        content {
                          priority = lookup(text_transformation.value, "priority", null)
                          type     = lookup(text_transformation.value, "type", null)
                        }
                      }
                    }
                  }

                  dynamic "byte_match_statement" {
                    for_each = lookup(statement.value, "byte_match_statement", [])

                    content {
                      positional_constraint = lookup(byte_match_statement.value, "positional_constraint", null)
                      search_string         = lookup(byte_match_statement.value, "search_string", null)

                      dynamic "field_to_match" {
                        for_each = lookup(byte_match_statement.value, "field_to_match", [])

                        content {
                          dynamic "uri_path" {
                            for_each = lookup(field_to_match.value, "uri_path", [])

                            content {}
                          }
                        }
                      }

                      dynamic "text_transformation" {
                        for_each = lookup(byte_match_statement.value, "text_transformation", [])

                        content {
                          priority = lookup(text_transformation.value, "priority", null)
                          type     = lookup(text_transformation.value, "type", null)
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          dynamic "or_statement" {
            for_each = lookup(statement.value, "or_statement", [])

            content {
              dynamic "statement" {
                for_each = lookup(or_statement.value, "statement", [])

                content {
                  dynamic "ip_set_reference_statement" {
                    for_each = lookup(statement.value, "ip_set_reference_statement", [])

                    content {
                      arn = lookup(ip_set_reference_statement.value, "arn", null)

                      dynamic "ip_set_forwarded_ip_config" {
                        for_each = lookup(ip_set_reference_statement.value, "ip_set_forwarded_ip_config", [])

                        content {
                          fallback_behavior = lookup(ip_set_forwarded_ip_config.value, "fallback_behavior", null)
                          header_name       = lookup(ip_set_forwarded_ip_config.value, "header_name", null)
                          position          = lookup(ip_set_forwarded_ip_config.value, "position", null)
                        }
                      }
                    }
                  }

                  dynamic "byte_match_statement" {
                    for_each = lookup(statement.value, "byte_match_statement", [])

                    content {
                      positional_constraint = lookup(byte_match_statement.value, "positional_constraint", null)
                      search_string         = lookup(byte_match_statement.value, "search_string", null)

                      dynamic "field_to_match" {
                        for_each = lookup(byte_match_statement.value, "field_to_match", [])

                        content {
                          dynamic "uri_path" {
                            for_each = lookup(field_to_match.value, "uri_path", [])

                            content {}
                          }

                          dynamic "query_string" {
                            for_each = lookup(field_to_match.value, "query_string", [])

                            content {}
                          }

                          dynamic "single_header" {
                            for_each = lookup(field_to_match.value, "single_header", [])

                            content {
                              name = lookup(single_header.value, "name", null)
                            }
                          }
                        }
                      }

                      dynamic "text_transformation" {
                        for_each = lookup(byte_match_statement.value, "text_transformation", [])

                        content {
                          priority = lookup(text_transformation.value, "priority", null)
                          type     = lookup(text_transformation.value, "type", null)
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          dynamic "managed_rule_group_statement" {
            for_each = lookup(statement.value, "managed_rule_group_statement", [])

            content {
              name        = lookup(managed_rule_group_statement.value, "name", null)
              vendor_name = lookup(managed_rule_group_statement.value, "vendor_name", null)

              dynamic "rule_action_override" {
                for_each = lookup(managed_rule_group_statement.value, "rule_action_override", [])

                content {
                  name = rule_action_override.value.name

                  dynamic "action_to_use" {
                    for_each = try(rule_action_override.value.action, null) == "count" ? [1] : []

                    content {
                      count {}
                    }
                  }

                  dynamic "action_to_use" {
                    for_each = try(rule_action_override.value.action, null) == "allow" ? [1] : []

                    content {
                      allow {}
                    }
                  }
                }
              }

              dynamic "scope_down_statement" {
                for_each = lookup(managed_rule_group_statement.value, "scope_down_statement", [])

                content {
                  dynamic "not_statement" {
                    for_each = lookup(scope_down_statement.value, "not_statement", [])

                    content {
                      dynamic "statement" {
                        for_each = lookup(not_statement.value, "statement", [])

                        content {
                          dynamic "byte_match_statement" {
                            for_each = lookup(statement.value, "byte_match_statement", [])

                            content {
                              positional_constraint = lookup(byte_match_statement.value, "positional_constraint", null)
                              search_string         = lookup(byte_match_statement.value, "search_string", null)

                              dynamic "field_to_match" {
                                for_each = lookup(byte_match_statement.value, "field_to_match", [])

                                content {
                                  dynamic "uri_path" {
                                    for_each = lookup(field_to_match.value, "uri_path", [])

                                    content {}
                                  }
                                }
                              }

                              dynamic "text_transformation" {
                                for_each = lookup(byte_match_statement.value, "text_transformation", [])

                                content {
                                  priority = lookup(text_transformation.value, "priority", null)
                                  type     = lookup(text_transformation.value, "type", null)
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          dynamic "not_statement" {
            for_each = lookup(statement.value, "not_statement", [])

            content {
              dynamic "statement" {
                for_each = lookup(not_statement.value, "statement", [])

                content {
                  dynamic "ip_set_reference_statement" {
                    for_each = try(statement.value.ip_set_reference_statement, [])

                    content {
                      arn = ip_set_reference_statement.value.arn

                      dynamic "ip_set_forwarded_ip_config" {
                        for_each = try(ip_set_reference_statement.value.ip_set_forwarded_ip_config, [])

                        content {
                          fallback_behavior = try(ip_set_forwarded_ip_config.value.fallback_behavior)
                          header_name       = try(ip_set_forwarded_ip_config.value.header_name)
                          position          = try(ip_set_forwarded_ip_config.value.position)
                        }
                      }
                    }
                  }

                  dynamic "byte_match_statement" {
                    for_each = lookup(statement.value, "byte_match_statement", [])

                    content {
                      positional_constraint = lookup(byte_match_statement.value, "positional_constraint", null)
                      search_string         = lookup(byte_match_statement.value, "search_string", null)

                      dynamic "field_to_match" {
                        for_each = lookup(byte_match_statement.value, "field_to_match", [])

                        content {
                          dynamic "single_header" {
                            for_each = lookup(field_to_match.value, "single_header", [])

                            content {
                              name = lookup(single_header.value, "name", null)
                            }
                          }
                        }
                      }

                      dynamic "text_transformation" {
                        for_each = lookup(byte_match_statement.value, "text_transformation", [])

                        content {
                          priority = lookup(text_transformation.value, "priority", null)
                          type     = lookup(text_transformation.value, "type", null)
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          dynamic "geo_match_statement" {
            for_each = lookup(statement.value, "geo_match_statement", [])

            content {
              country_codes = geo_match_statement.value.country_codes

              dynamic "forwarded_ip_config" {
                for_each = lookup(geo_match_statement.value, "forwarded_ip_config", [])

                content {
                  fallback_behavior = forwarded_ip_config.value.fallback_behavior
                  header_name       = forwarded_ip_config.value.header_name
                }
              }
            }
          }
        }
      }
    }
  }

  tags = merge(var.tags, tomap({
    Name = var.web_acl_name
  }))

  depends_on = [
    aws_wafv2_ip_set.this
  ]
}

## web association
resource "aws_wafv2_web_acl_association" "this" {
  for_each = toset(var.association_resource_arns)

  resource_arn = each.value
  web_acl_arn  = one(aws_wafv2_web_acl.this[*].arn)
}

################################################################
## ip set
################################################################
resource "aws_wafv2_ip_set" "this" {
  for_each = { for x in var.ip_set : x.name => x }

  name               = each.value.name
  description        = each.value.description
  scope              = each.value.scope
  ip_address_version = each.value.ip_address_version
  addresses          = each.value.addresses

  tags = merge(var.tags, tomap({
    Name = each.value.name
  }))
}
