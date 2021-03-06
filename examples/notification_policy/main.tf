module "label" {
  source = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"

  attributes = var.attributes
  delimiter  = var.delimiter
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}

module "team" {
  source = "../../modules/team"

  opsgenie_provider_api_key = var.opsgenie_provider_api_key

  team = {
    name        = "owner-team"
    description = "owner-team-description"
  }
}

module "notification_policy" {
  source = "../../modules/notification_policy"

  opsgenie_provider_api_key = var.opsgenie_provider_api_key

  notification_policy = {
    name    = module.label.id
    team_id = module.team.team_id

    filter = {
      type = "match-all-conditions"
      conditions = [{
        field          = "tags"
        operation      = "contains"
        expected_value = "recommendation:auto-close"
      }]
    }

    auto_close_action = {
      time_unit   = "minutes"
      time_amount = 5
    }
  }
}
