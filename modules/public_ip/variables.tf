variable "product_area" {
  type        = string
  description = "Owning organization, functional team, or portfolio of the resources to which the application is utilizing"
  validation {
    condition     = (var.product_area != null && length(var.product_area) == 3)
    error_message = "Invalid 'product_area'. It must be exactly 3 characters long."
  }
}

variable "environment" {
  description = "Environment of resources."
  type        = string
}

variable "name" {
  description = "Specifies the name of the Public IP. Changing this forces a new Public IP to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group where this Public IP should exist. Changing this forces a new Public IP to be created."
  type        = string
}

variable "location" {
  description = "Specifies the supported Azure location where the Public IP should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic."
  type        = string
  default     = "Static"
}

variable "zones" {
  description = "A collection containing the availability zone to allocate the Public IP in. Changing this forces a new resource to be created."
  type        = list(string)
  default     = null
}

variable "sku" {
  description = "The SKU name of the public ip. Possible values are Basic and Standard."
  type        = string
  default     = "Standard"
}

variable "domain_name_label" {
  description = "(Optional) Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}
