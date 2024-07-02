## Inspired by https://github.com/kaysalawu/azure-network-terraform/tree/main/modules/network-manager

####################################################
# network groups
####################################################

# vnet
#-----------------------

# group

resource "azurerm_network_manager_network_group" "vnet" {
  for_each           = { for ng in var.network_groups : ng.ng_name => ng }
  name               = coalesce(each.value.custom_name, data.azurecaf_name.network_manager_group[each.key].result)
  network_manager_id = azurerm_network_manager.this.id
  description        = each.value.description
}

# static members

resource "azurerm_network_manager_static_member" "vnet" {
  for_each                  = { for member in local.static_members_vnet : member.resource_id => member }
  name                      = lower(each.value.name)
  network_group_id          = each.value.network_group_id
  target_virtual_network_id = each.value.resource_id
}

# subnet
#-----------------------

# TBD

####################################################
# configuration
####################################################

# connectivity
#-----------------------

resource "azurerm_network_manager_connectivity_configuration" "this" {
  for_each              = { for cc in var.connectivity_configurations : cc.connectivity_name => cc }
  name                  = coalesce(each.value.custom_name, data.azurecaf_name.network_manager_connectivity_configuration[each.key].result)
  network_manager_id    = azurerm_network_manager.this.id
  connectivity_topology = each.value.connectivity_topology

  dynamic "hub" {
    for_each = each.value.hub[*]
    content {
      resource_id   = each.value.hub.resource_id
      resource_type = each.value.hub.resource_type
    }
  }

  applies_to_group {
    group_connectivity  = each.value.applies_to_group.group_connectivity
    network_group_id    = azurerm_network_manager_network_group.vnet[each.value.network_group_name].id
    global_mesh_enabled = each.value.applies_to_group.global_mesh_enabled
    use_hub_gateway     = each.value.applies_to_group.use_hub_gateway
  }
}

# security
#-----------------------

resource "azurerm_network_manager_security_admin_configuration" "this" {
  for_each           = { for sac in var.security_admin_configurations : sac.sac_name => sac }
  name               = coalesce(each.value.custom_name, data.azurecaf_name.network_manager_security_admin[each.key].result)
  network_manager_id = azurerm_network_manager.this.id
}

# default

resource "azurerm_network_manager_admin_rule_collection" "default" {
  for_each                        = { for sac in var.security_admin_configurations : sac.sac_name => sac.apply_default_rules }
  name                            = "arc-${each.key}-default"
  security_admin_configuration_id = azurerm_network_manager_security_admin_configuration.this[each.key].id
  network_group_ids               = [for ng in var.network_groups : azurerm_network_manager_network_group.vnet[ng.name].id]
}

resource "azurerm_network_manager_admin_rule" "default" {
  for_each                 = { for rule in local.default_admin_rules : rule.name => rule }
  name                     = "ar-${each.key}"
  admin_rule_collection_id = each.value.admin_rule_collection_id
  description              = each.value.description
  action                   = each.value.action
  direction                = each.value.direction
  priority                 = each.value.priority
  protocol                 = each.value.protocol
  destination_port_ranges  = each.value.destination_port_ranges

  dynamic "source" {
    for_each = each.value.source
    content {
      address_prefix_type = source.value.address_prefix_type
      address_prefix      = source.value.address_prefix
    }
  }

  dynamic "destination" {
    for_each = each.value.destinations
    content {
      address_prefix_type = destination.value.address_prefix_type
      address_prefix      = destination.value.address_prefix
    }
  }
}

####################################################
# deployment
####################################################

# connectivity
#-----------------------

resource "azurerm_network_manager_deployment" "connectivity" {
  count              = length(local.connectivity_configuration_ids_to_deploy) > 0 ? 1 : 0
  network_manager_id = azurerm_network_manager.this.id
  location           = var.location
  scope_access       = "Connectivity"

  configuration_ids = local.connectivity_configuration_ids_to_deploy

  triggers = {
    reconfiguration_hash = jsonencode({
      configuration_ids = local.connectivity_configuration_ids_to_deploy
    })
  }
  depends_on = [
    azurerm_network_manager_connectivity_configuration.this,
    azurerm_network_manager_security_admin_configuration.this,
    azurerm_network_manager_admin_rule.default,
  ]
}

# security
#-----------------------

resource "azurerm_network_manager_deployment" "security" {
  count              = length(local.security_configuration_ids_to_deploy) > 0 ? 1 : 0
  network_manager_id = azurerm_network_manager.this.id
  location           = var.location
  scope_access       = "SecurityAdmin"
  configuration_ids  = local.security_configuration_ids_to_deploy
  triggers = {
    reconfiguration_hash = jsonencode({
      configuration_ids = local.security_configuration_ids_to_deploy
    })
    admin_rule_changes = jsonencode({
      protocol                = [for rule in local.default_rules_high_risk : rule.protocol]
      destination_port_ranges = [for rule in local.default_rules_high_risk : rule.destination_port_ranges]
      rule_collections        = [for sac in var.security_admin_configurations : sac.rule_collections if sac.deploy]
    })
  }
  depends_on = [
    azurerm_network_manager_deployment.connectivity,
  ]
}
