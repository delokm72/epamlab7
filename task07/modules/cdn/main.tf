resource "azurerm_cdn_frontdoor_profile" "door" {
  name                = var.profile_name
  resource_group_name = var.resource_group_name
  sku_name            = var.door_profile_sku_name
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.door.id
  name                     = var.endpoint_name
}

resource "azurerm_cdn_frontdoor_origin_group" "cdn_og" {
  name                     = var.origin_group_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.door.id
  # values from example, block is required
  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 16
    successful_samples_required        = 3
  }
  # not mandatory in docs but can be requested for success create!
  health_probe {
    interval_in_seconds = 100
    # не варто просто вказувати / Коли Front Door робить HEAD запит на корінь (/)
    # Blob Storage (https://<account>.blob.core.windows.net/), Azure Storage очікує обов'язковий query-параметр
    # для REST API (наприклад, ?comp=list), щоб показати список контейнерів.
    # Оскільки Front Door робить чистий запит без параметрів, Storage Account повертає помилку 400 Bad Request
    path         = "/blob.txt"
    protocol     = "Https"
    request_type = "HEAD"
  }
}

resource "azurerm_cdn_frontdoor_origin" "cdn_origin" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.cdn_og.id
  certificate_name_check_enabled = false
  enabled                        = true
  host_name                      = var.blob_hostname
  origin_host_header             = var.blob_hostname
  name                           = var.origin_name
}

resource "azurerm_cdn_frontdoor_route" "cdn_route" {
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.cdn_og.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.cdn_origin.id]
  name                          = var.door_route_name
  forwarding_protocol           = "MatchRequest"
  https_redirect_enabled        = true
  link_to_default_domain        = true
  patterns_to_match             = ["/*"]
  supported_protocols = [
    "Http",
    "Https"
  ]
  # wait for other resource to be created
  depends_on = [
    azurerm_cdn_frontdoor_origin.cdn_origin
  ]
}

