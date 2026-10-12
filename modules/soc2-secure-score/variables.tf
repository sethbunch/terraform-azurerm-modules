variable "name_prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
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

variable "log_analytics_workspace_id" {
  description = "The ID of the log analytics workspace from Module 1"
  type        = string
}

variable "automation_enabled" {
  description = "Whether the Defender continuous export automation is enabled. Set false to pause the export without destroying it."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Standard compliance tags"
  type        = map(string)
  default = {
    "Compliance" = "soc2"
  }
}

variable "event_sources" {
  description = "Which Defender for Cloud event types to export to Log Analytics"
  type        = list(string)
  default     = ["RegulatoryComplianceAssessmentSnapshot", "SecureScoreControlsSnapshot", "SecureScoresSnapshot"]

  validation {
    condition = alltrue([
      for source in var.event_sources : contains([
        "Alerts", "Assessments", "AssessmentsSnapshot",
        "RegulatoryComplianceAssessment", "RegulatoryComplianceAssessmentSnapshot",
        "SecureScoreControls", "SecureScoreControlsSnapshot",
        "SecureScores", "SecureScoresSnapshot",
        "SubAssessments", "SubAssessmentsSnapshot"
      ], source)
    ])
    error_message = "Event sources must be valid Defender for Cloud export types (e.g. SecureScoresSnapshot)."
  }
}