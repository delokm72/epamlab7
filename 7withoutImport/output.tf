output "endpoint_hostname" {
  description = "Azure CDN Front Door Endpoint Hostname"
  value       = module.cdn.hostname
}

output "blob_url" {
  description = "..."
  value       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.container.name}/${azurerm_storage_blob.blob.name}"
}
