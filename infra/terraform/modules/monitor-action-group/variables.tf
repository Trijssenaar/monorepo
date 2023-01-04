variable "resource_group_name" {
  type        = string
  description = "Name of the resourcegroup"
}
variable "support_name" {
  type        = string
  description = "Name of the support team"
}

variable "support_email" {
  type        = string
  description = "Email address of the support team"
}

# Action Group Variables
variable "action_group" {
  description = "The name of the action group"

  type = object({
    name       = string
    short_name = string
  })
}
