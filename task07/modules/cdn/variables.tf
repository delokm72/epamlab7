variable "blob_hostname" {
  description = "..."
  type = string
}

variable "location" {
  description = "..."
  type = string
}

variable "resource_group_name" {
  description = "..."
  type = string
}

variable "profile_name" {
  description = "..."
  type = string
}

variable "endpoint_name" {
  description = "..."
  type = string
}

variable "origin_group_name" {
  type = string
  description = "..."
}

variable "origin_name" {
  type = string
}

variable "door_profile_sku_name" {
  type    = string
  default = "Standard_AzureFrontDoor"
}

variable "door_route_name" {
  type    = string
  default = "default"
}