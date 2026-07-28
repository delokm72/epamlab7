locals {
  prefix                 = "cmtr-53z813ye-mod7"
  frontdoor_profile_name = "${local.prefix}-fd-profile"
  endpoint_name          = "${local.prefix}-fd-endpoint"
  origin_group_name      = "${local.prefix}-fd-origin-group"
  origin_name            = "${local.prefix}-fd-origin"
}