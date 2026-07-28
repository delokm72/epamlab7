variable "blob_hostname" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "profile_name" {
  type = string
}

variable "endpoint_name" {
  type = string
}

variable "origin_group_name" {
  type = string
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