data "azurerm_subscription" "primary" {}

resource "azurerm_resource_group" "activity_log" {
  name     = "${var.name_prefix}-audit-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "log_storage" {
  name                       = "${lower(var.name_prefix)}auditlogs001"
  resource_group_name        = azurerm_resource_group.activity_log.name
  location                   = var.location
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"
  tags                       = var.tags
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.name_prefix}-audit-law"
  location            = var.location
  resource_group_name = azurerm_resource_group.activity_log.name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_days
  tags                = var.tags
}

resource "azurerm_eventhub_namespace" "log_stream" {
  count               = var.enable_event_hub ? 1 : 0
  name                = "${var.name_prefix}-audit-eh-ns"
  location            = var.location
  resource_group_name = azurerm_resource_group.activity_log.name
  sku                 = "Standard"
  capacity            = 1
  tags                = var.tags
}

resource "azurerm_eventhub" "log_stream" {
  count             = var.enable_event_hub ? 1 : 0
  name              = "${var.name_prefix}-audit-eh"
  namespace_id      = azurerm_eventhub_namespace.log_stream[0].id
  partition_count   = 2
  message_retention = 1
}

resource "azurerm_eventhub_authorization_rule" "log_stream" {
  count               = var.enable_event_hub ? 1 : 0
  name                = "${var.name_prefix}-audit-eh-auth"
  namespace_name      = azurerm_eventhub_namespace.log_stream[0].name
  eventhub_name       = azurerm_eventhub.log_stream[0].name
  resource_group_name = azurerm_resource_group.activity_log.name
  send                = true
}

resource "azurerm_monitor_diagnostic_setting" "log-ds" {
  name                           = "${var.name_prefix}-audit-ds"
  target_resource_id             = data.azurerm_subscription.primary.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics.id
  storage_account_id             = azurerm_storage_account.log_storage.id
  eventhub_name                  = var.enable_event_hub ? azurerm_eventhub.log_stream[0].name : null
  eventhub_authorization_rule_id = var.enable_event_hub ? azurerm_eventhub_authorization_rule.log_stream[0].id : null

  dynamic "enabled_log" {
    for_each = var.log_categories
    content {
      category_group = enabled_log.value
    }
  }
}
















