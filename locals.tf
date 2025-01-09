locals {
  scope_subscriptions_ids = [
    for sub in try(var.network_manager_scope.subscription_ids, []) : startswith(sub, "/subscriptions/") ? sub : "/subscriptions/${sub}"
  ]

  default_rules_high_risk = {
    "tcp-high-risk" = {
      description = "tcp-high-risk"
      action      = "Deny"
      direction   = "Inbound"
      priority    = 101
      protocol    = "Tcp"
      destination_port_ranges = [
        "20", "21", "23", "111", "119", "135", "161", "162", "445", "512", "514", "593", "873", "2049", "5800", "5900", "11211",
      ]
      source = [
        { address_prefix_type = "IPPrefix", address_prefix = "*" }
      ]
      destinations = [
        { address_prefix_type = "IPPrefix", address_prefix = "*" }
      ]
    },
    "udp-high-risk" = {
      description = "udp-high-risk"
      action      = "Deny"
      direction   = "Inbound"
      priority    = 102
      protocol    = "Udp"
      destination_port_ranges = [
        "111", "135", "162", "593", "2049",
      ]
      source = [
        { address_prefix_type = "IPPrefix", address_prefix = "*" }
      ]
      destinations = [
        { address_prefix_type = "IPPrefix", address_prefix = "*" }
      ]
    }
  }

  static_members_vnet = flatten([
    for ng in var.network_groups : [
      for id in ng.static_members : {
        key_name         = "${ng.ng_name}-${basename(id)}"
        name             = basename(id)
        resource_id      = id
        network_group_id = azurerm_network_manager_network_group.main[ng.ng_name].id
      }
    ] if ng.member_type == "VirtualNetwork"
  ])

  default_admin_rules = flatten([
    for sac in var.security_admin_configurations : [
      for k, v in local.default_rules_high_risk : {
        name                     = "${sac.sac_name}-${k}"
        admin_rule_collection_id = azurerm_network_manager_admin_rule_collection.default[sac.sac_name].id
        description              = v.description
        action                   = v.action
        direction                = v.direction
        priority                 = v.priority
        protocol                 = v.protocol
        destination_port_ranges  = v.destination_port_ranges
        source                   = v.source
        destinations             = v.destinations
      }
    ] if sac.apply_default_rules
  ])
  custom_rule_collections = flatten([
    for sac in var.security_admin_configurations : [
      for rc in sac.rule_collections : {
        name = "${sac.sac_name}-${rc.name}"
        sac  = sac
        rc   = rc
      }
    ]
  ])
  custom_rules = flatten([
    for sac in var.security_admin_configurations : [
      for rc in sac.rule_collections : [
        for rule in rc.rules : {
          name                     = "${rc.name}-${rule.name}"
          admin_rule_collection_id = azurerm_network_manager_admin_rule_collection.main["${sac.sac_name}-${rc.name}"].id
          description              = rule.description
          action                   = rule.action
          direction                = rule.direction
          priority                 = rule.priority
          protocol                 = rule.protocol
          destination_port_ranges  = rule.destination_port_ranges
          source                   = rule.source
          destinations             = rule.destinations
        }
      ]
    ]
  ])
  connectivity_configuration_ids_to_deploy = concat(
    var.connectivity_deployment.configuration_ids,
    [for c in var.connectivity_deployment.configuration_names :
      azurerm_network_manager_connectivity_configuration.main[c].id
      if contains(keys(azurerm_network_manager_connectivity_configuration.main), c)
    ]
  )
  security_configuration_ids_to_deploy = concat(
    var.security_deployment.configuration_ids,
    [for c in var.security_deployment.configuration_names :
      azurerm_network_manager_security_admin_configuration.main[c].id
      if contains(keys(azurerm_network_manager_security_admin_configuration.main), c)
    ]
  )
}
