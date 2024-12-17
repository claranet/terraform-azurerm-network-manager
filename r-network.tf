## Inspired by https://github.com/kaysalawu/azure-network-terraform/tree/main/modules/network-manager

####################################################
# network groups
####################################################

# vnet
#-----------------------

# group

resource "azurerm_network_manager_network_group" "main" {
  for_each           = { for ng in var.network_groups : ng.ng_name => ng }
  name               = coalesce(each.value.custom_name, data.azurecaf_name.network_manager_group[each.key].result)
  network_manager_id = azurerm_network_manager.main.id
  description        = each.value.description
}

# static members

resource "azurerm_network_manager_static_member" "main" {
  for_each                  = { for member in local.static_members_vnet : member.key_name => member }
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

resource "azurerm_network_manager_connectivity_configuration" "main" {
  for_each              = { for cc in var.connectivity_configurations : cc.connectivity_name => cc }
  name                  = coalesce(each.value.custom_name, data.azurecaf_name.network_manager_connectivity_configuration[each.key].result)
  network_manager_id    = azurerm_network_manager.main.id
  connectivity_topology = each.value.connectivity_topology

  dynamic "hub" {
    for_each = each.value.hub[*]
    content {
      resource_id   = each.value.hub.resource_id
      resource_type = each.value.hub.resource_type
    }
  }

  dynamic "applies_to_group" {
    for_each = each.value.applies_to_groups
    iterator = grp

    content {
      group_connectivity  = grp.value.direct_connectivity_enabled ? "DirectlyConnected" : "None"
      network_group_id    = azurerm_network_manager_network_group.main[grp.value.network_group_name].id
      global_mesh_enabled = grp.value.global_mesh_enabled
      use_hub_gateway     = grp.value.use_hub_gateway
    }
  }
}

# security
#-----------------------

resource "azurerm_network_manager_security_admin_configuration" "main" {
  for_each           = { for sac in var.security_admin_configurations : sac.sac_name => sac }
  name               = coalesce(each.value.custom_name, data.azurecaf_name.network_manager_security_admin[each.key].result)
  network_manager_id = azurerm_network_manager.main.id
}

# default

resource "azurerm_network_manager_admin_rule_collection" "default" {
  for_each                        = { for sac in var.security_admin_configurations : sac.sac_name => sac.apply_default_rules }
  name                            = "arc-${each.key}-default"
  security_admin_configuration_id = azurerm_network_manager_security_admin_configuration.main[each.key].id
  network_group_ids               = [for ng in var.network_groups : azurerm_network_manager_network_group.main[ng.ng_name].id]
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

# custom rules

resource "azurerm_network_manager_admin_rule_collection" "main" {
  for_each                        = { for collection in local.custom_rule_collections : collection.name => collection }
  name                            = "arc-${each.key}"
  description                     = each.value.rc.description
  security_admin_configuration_id = azurerm_network_manager_security_admin_configuration.main[each.value.sac.sac_name].id
  network_group_ids               = [for ng in each.value.rc.network_group_names : azurerm_network_manager_network_group.main[ng].id]
}

resource "azurerm_network_manager_admin_rule" "main" {
  for_each                 = { for rule in local.custom_rules : rule.name => rule }
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
  network_manager_id = azurerm_network_manager.main.id
  location           = var.location
  scope_access       = "Connectivity"

  configuration_ids = local.connectivity_configuration_ids_to_deploy

  triggers = {
    reconfiguration_hash = jsonencode({
      configuration_ids = local.connectivity_configuration_ids_to_deploy
    })
    connectivity_changes = jsonencode(var.connectivity_configurations)
  }
  depends_on = [
    azurerm_network_manager_connectivity_configuration.main,
    azurerm_network_manager_security_admin_configuration.main,
    azurerm_network_manager_admin_rule.default,
  ]
}

# security
#-----------------------

resource "azurerm_network_manager_deployment" "security" {
  count              = length(local.security_configuration_ids_to_deploy) > 0 ? 1 : 0
  network_manager_id = azurerm_network_manager.main.id
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
    connectivity_changes = jsonencode(var.connectivity_configurations)
  }
  depends_on = [
    azurerm_network_manager_deployment.connectivity,
  ]
}
