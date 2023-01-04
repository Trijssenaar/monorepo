resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  lifecycle {
    ignore_changes = [tags]
  }
}

#Errors can occure when the workspace has not properly finished, add a wait timer to give
#it just a little bit more time
resource "time_sleep" "wait_for_workspace" {
  create_duration = "120s"

  depends_on = [azurerm_log_analytics_workspace.log_analytics_workspace]
}

resource "azurerm_monitor_scheduled_query_rules_alert" "log_operations_errors" {
  name                = "log_operations_errors_alert"
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [time_sleep.wait_for_workspace]

  action {
    action_group = [var.actiongroup_id]
  }
  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  description    = "Alert when errors occur in the _log_operations()"
  enabled        = true
  # Count all requests with server error result code grouped into 5-minute bins
  query       = <<-QUERY
    _LogOperation | where Level == "Error"
  QUERY
  severity    = 1
  frequency   = 5
  time_window = 5
  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "log_operations_warnings" {
  name                = "log_operations_warnings_alert"
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [time_sleep.wait_for_workspace]

  action {
    action_group = [var.actiongroup_id]
  }
  data_source_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  description    = "Alert when warnings occur in the _log_operations()"
  enabled        = true
  # Count all requests with server error result code grouped into 5-minute bins
  query       = <<-QUERY
    _LogOperation | where Level == "Warning"
  QUERY
  severity    = 1
  frequency   = 1440
  time_window = 1440
  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }
}
