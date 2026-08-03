variable "name_prefix" {
  description = "Prefix for all resources (eg. corp-prod)"
  type        = string
}

variable "location" {
  description = "The location of the resource."
  type        = string
  default     = "eastus2"
  validation {
    condition     = contains(["eastus2", "westus", "southcentralus", "mexicocentral", "northcentralus"], var.location)
    error_message = "Location must be one of: eastus2, westus, southcentralus, mexicocentral, northcentralus."
  }
}

variable "retention_days" {
  description = "How many days to retain Activity Logs in storage."
  type        = number
  default     = 90
  validation {
    condition     = var.retention_days >= 30 && var.retention_days <= 3650
    error_message = "Retention days must be between 30 and 3650 days (Azure max)."
  }
}

variable "tags" {
  description = "Standard compliance tags"
  type        = map(string)
  default = {
    "compliance" = "soc2"
  }
}

variable "log_categories" {
  description = "List of log categories to enable for diagnostic settings"
  type        = list(string)
  default     = ["allLogs"]
}

variable "enable_event_hub" {
  description = "Enable Event Hub for log streaming to external SIEM."
  type        = bool
  default     = false
}