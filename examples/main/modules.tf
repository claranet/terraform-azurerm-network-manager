module "network_manager" {
  source  = "claranet/network-manager/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.name

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  network_manager_scope_accesses = [
    "Connectivity",
    "SecurityAdmin"
  ]

  network_manager_scope = {
    subscription_ids = [
      data.azurerm_subscription.current.id,
    ]
  }

  network_manager_description = "Global"

  network_groups = [
    {
      ng_name     = "mesh-global"
      description = "All floating spokes in prod"
      member_type = "VirtualNetwork"
      static_members = [
        # module.spoke3.vnet.id,
      ]
    },
    {
      ng_name     = "hubspoke-euw"
      description = "All spokes in prod region1"
      member_type = "VirtualNetwork"
      static_members = [
        # module.spoke1.vnet.id,
        # module.spoke2.vnet.id,
      ]
    },
  ]

  connectivity_configurations = [
    {
      connectivity_name     = "mesh-global"
      connectivity_topology = "Mesh"
      global_mesh_enabled   = true
      applies_to_groups = [{
        network_group_name  = "mesh-global"
        group_connectivity  = "DirectlyConnected"
        global_mesh_enabled = true
      }]
    },
    {
      connectivity_name     = "hubspoke-region-euw"
      deploy                = true
      connectivity_topology = "HubAndSpoke"
      global_mesh_enabled   = false
      applies_to_groups = [{
        network_group_name  = "hubspoke-euw"
        group_connectivity  = "None"
        global_mesh_enabled = false
        use_hub_gateway     = true
      }]
      # hub = {
      #   resource_id   = module.hub1.vnet.id
      #   resource_type = "Microsoft.Network/virtualNetworks"
      # }
    },
  ]

  security_admin_configurations = [
    {
      deploy              = true
      apply_default_rules = true
      sac_name            = "hubspoke-euw-soc1"
      rule_collections    = []
    },
    {
      sac_name            = "hubspoke-euw-soc2"
      apply_default_rules = true
      rule_collections    = []
    },
  ]

  connectivity_deployment = {
    configuration_names = ["hubspoke-region-euw", ]
  }

  security_deployment = {
    configuration_names = ["hubspoke-euw-soc1"]
    configuration_ids   = []
  }

  logs_destinations_ids = [
    module.run.logs_storage_account_id,
    module.run.log_analytics_workspace_id
  ]

  extra_tags = {
    foo = "bar"
  }
}
