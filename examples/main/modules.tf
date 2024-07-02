module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "run" {
  source  = "claranet/run/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

module "network_manager" {
  source  = "claranet/network-manager/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

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
        # module.spoke3.vnet_id,
      ]
    },
  ]

  connectivity_configurations = [
    {
      connectivity_name     = "mesh-global"
      network_group_name    = "mesh-global"
      connectivity_topology = "Mesh"
      global_mesh_enabled   = true
      applies_to_group = {
        group_connectivity  = "DirectlyConnected"
        global_mesh_enabled = true
      }
    },
  ]


  logs_destinations_ids = [
    module.run.logs_storage_account_id,
    module.run.log_analytics_workspace_id
  ]

  extra_tags = {
    foo = "bar"
  }
}
