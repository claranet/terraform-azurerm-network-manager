resource "azurerm_network_manager" "this" {
  name = local.network_manager_name

  location = var.location

  resource_group_name = var.resource_group_name
  scope_accesses      = var.network_manager_scope_accesses
  description         = var.network_manager_description

  dynamic "scope" {
    for_each = [var.network_manager_scope]
    content {
      management_group_ids = scope.value.management_group_ids
      subscription_ids     = local.scope_subscriptions_ids
    }
  }

  dynamic "timeouts" {
    for_each = var.network_manager_timeouts[*]
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }

  tags = merge(local.default_tags, var.extra_tags)
}
