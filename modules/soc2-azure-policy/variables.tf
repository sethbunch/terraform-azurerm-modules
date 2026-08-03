variable "name_prefix" {
  description = "Name for each resource"
  type        = string
}

variable "tags" {
  description = "Standard compliance tags"
  type        = map(string)
  default = {
    "compliance" = "soc2"
  }
}

variable "allowed_locations" {
  description = "List of allowed locations based on compliance standards."
  type        = list(string)
}

variable "required_tags" {
  description = "The tags required based on compliance standards."
  type        = list(string)
}