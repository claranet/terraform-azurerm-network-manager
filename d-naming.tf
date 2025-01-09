# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
data "azurecaf_name" "network_manager" {
  name          = var.stack
  resource_type = "azurerm_resource_group" # "azurerm_network_manager"
  prefixes      = compact(["vnm", local.name_prefix])
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "network_manager_group" {
  for_each = { for ng in var.network_groups : ng.ng_name => ng }

  name          = var.stack
  resource_type = "azurerm_resource_group" # "azurerm_network_manager_network_group"
  prefixes      = compact(["ng", local.name_prefix])
  suffixes      = compact([var.client_name, local.name_suffix, each.key])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "network_manager_connectivity_configuration" {
  for_each = { for cc in var.connectivity_configurations : cc.connectivity_name => cc }

  name          = var.stack
  resource_type = "azurerm_resource_group"
  prefixes      = compact(["cc-ng", local.name_prefix])
  suffixes      = compact([var.client_name, local.name_suffix, each.key])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "network_manager_security_admin" {
  for_each = { for sac in var.security_admin_configurations : sac.sac_name => sac }

  name          = var.stack
  resource_type = "azurerm_resource_group"
  prefixes      = compact(["sac-ng", local.name_prefix])
  suffixes      = compact([var.client_name, local.name_suffix, each.key])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}
