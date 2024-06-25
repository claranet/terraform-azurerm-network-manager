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
