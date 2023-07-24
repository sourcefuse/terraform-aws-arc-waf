web_acl_rules = [
  ## AWS-AWSManagedRulesAmazonIpReputationList
  {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 0

    override_action = [{ none = [{}] }]

    visibility_config = [
      {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
        sampled_requests_enabled   = true
      }
    ]

    statement = [
      {
        managed_rule_group_statement = [
          {
            name        = "AWSManagedRulesAmazonIpReputationList"
            vendor_name = "AWS"
          }
        ]
      }
    ]
  },

  ## AWS-AWSManagedRulesKnownBadInputsRuleSet
  {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 1

    override_action = [{ none = [{}] }]

    visibility_config = [
      {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
        sampled_requests_enabled   = true
      }
    ]

    statement = [
      {
        managed_rule_group_statement = [
          {
            name        = "AWSManagedRulesKnownBadInputsRuleSet"
            vendor_name = "AWS"
          }
        ]
      }
    ]
  },

  ## AWS-AWSManagedRulesWindowsRuleSet
  {
    name     = "AWS-AWSManagedRulesWindowsRuleSet"
    priority = 2

    override_action = [{ none = [{}] }]

    visibility_config = [
      {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-AWSManagedRulesWindowsRuleSet"
        sampled_requests_enabled   = true
      }
    ]

    statement = [
      {
        managed_rule_group_statement = [
          {
            name        = "AWSManagedRulesWindowsRuleSet"
            vendor_name = "AWS"

            excluded_rule = [
              {
                name = "WindowsShellCommands_BODY"
              }
            ]
          }
        ]
      }
    ]
  },

  ## AWS-AWSManagedRulesCommonRuleSet
  {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 3

    override_action = [{ none = [{}] }]

    visibility_config = [
      {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
        sampled_requests_enabled   = true
      }
    ]

    statement = [
      {
        managed_rule_group_statement = [{
          name        = "AWSManagedRulesCommonRuleSet"
          vendor_name = "AWS"

          excluded_rule = [
            {
              name = "GenericRFI_BODY"
            },
            {
              name = "GenericRFI_QUERYARGUMENTS"
            },
            {
              name = "NoUserAgent_HEADER"
            },
            {
              name = "SizeRestrictions_BODY"
            },
            {
              name = "SizeRestrictions_Cookie_HEADER"
            },
            {
              name = "SizeRestrictions_QUERYSTRING"
            }
          ]
          scope_down_statement = [
            {
              not_statement = [
                {
                  statement = [
                    {
                      byte_match_statement = [
                        {
                          positional_constraint = "CONTAINS"
                          search_string         = "/api/v2"

                          field_to_match = [{ uri_path = [{}] }]

                          text_transformation = [
                            {
                              priority = 0
                              type     = "NONE"
                            }
                          ]
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
          }
        ]
      }
    ]
  },

  ## AWS-AWSManagedRulesSQLiRuleSet
  {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 4

    override_action = [{ none = [{}] }]

    visibility_config = [
      {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
        sampled_requests_enabled   = true
      }
    ]

    statement = [
      {
        managed_rule_group_statement = [
          {
            name        = "AWSManagedRulesSQLiRuleSet"
            vendor_name = "AWS"

            excluded_rule = [
              {
                name = "SQLi_QUERYARGUMENTS"
              }
            ]
          }
        ]
      }
    ]
  },
]
