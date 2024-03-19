variable "product_area" {
  type        = string
  description = "Owning organization, functional team, or portfolio of the resources to which the application is utilizing"
  validation {
    condition     = (var.product_area != null && length(var.product_area) == 3)
    error_message = "Invalid 'product_area'. It must be exactly 3 characters long."
  }
}

variable "allowed_origins" {
  description = "List of allowed origins for cors."
  type        = list(string)
}

variable "containers" {
  description = "List of containers to be created."
  default     = {}
  type = map(object({
    name = string
  }))
}

variable "environment" {
  description = "Environment of resources."
  type        = string
}

variable "file_shares" {
  description = "List of file share to be created."
  default     = {}
  type = map(object({
    access_tier = string
    name        = string
    quota       = number
  }))
}

variable "location" {
  description = "Location of resource."
  type        = string
}

variable "versioning_enabled" {
  description = "Versioning enabled."
  default     = false
  type        = bool
}

variable "delete_retention_policy" {
  description = "Number of days that the blob should be retained, between 1 and 365 days."
  default     = 7
  type        = number
}
