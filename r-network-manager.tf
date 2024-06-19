resource "azurerm_network_manager" "network_manager" {
  name = local.network_manager_name

  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(local.default_tags, var.extra_tags)
}
