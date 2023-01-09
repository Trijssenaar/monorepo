resource "azurerm_monitor_action_group" "support_team" {

  name                = var.action_group.name
  short_name          = var.action_group.short_name
  resource_group_name = var.resource_group_name
  email_receiver {
    name          = var.support_name
    email_address = var.support_email
  }
  
}
