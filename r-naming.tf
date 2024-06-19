data "azurecaf_name" "network_manager" {
  name          = var.stack
  resource_type = "azurerm_network_manager"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}
