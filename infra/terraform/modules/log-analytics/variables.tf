variable "resource_group_name" {
  type        = string
  description = "The Name of the Resource Group to create the resources in."
}

variable "name" {
  type        = string
  description = "The Name of the Log Analytics Workspace."
}

variable "location" {
  type        = string
  description = "The Location of the Log Analytics Workspace."
}

variable "actiongroup_id" {
  type        = string
  description = "id of the actiongroup to send alerts to"
}
