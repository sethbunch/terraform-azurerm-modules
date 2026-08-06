variable "name_prefix" {
  description = "Prefix for all resources "
  type        = string
}

variable "security_contact_email" {
  description = "Email used for alerts contact"
  type        = string
}

variable "tags" {
  description = "Standard compliance tags"
  type        = map(string)
  default = {
    "Compliance" = "soc2"
  }
}

variable "defender_plan_resource_types" {
  description = "Which defender plans to enable"
  type        = list(string)
}

variable "security_contact_phone" {
  description = "Phone number used for alerts contact"
  type        = string
}

variable "enable_vm_vuln_scan" {
  description = "Toggle for vuln scan"
  type        = bool
  default     = true
}

variable "enable_defender_for_endpoint" {
  description = "Toggle for MDE integration"
  type        = bool
  default     = true
}
