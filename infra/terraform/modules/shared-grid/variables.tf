variable "environment" {
  type        = string
  description = "The environment to deploy into, e.g. DEV, TST, ACC, PRD, etc."
}

variable "resource-group-name" {
  type        = string
  description = "Name of the resourcegroup"
}

variable "location" {
  type        = string
  description = "The Azure location where the resources should be created."
}
