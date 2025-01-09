variable "network_groups" {
  description = "Network groups to be created in the Azure Network Manager."
  type = list(object({
    ng_name        = string
    custom_name    = optional(string)
    description    = optional(string)
    member_type    = optional(string, "VirtualNetwork")
    static_members = optional(list(string))
  }))
  default  = []
  nullable = false
}

variable "connectivity_configurations" {
  description = "Connectivity configurations to be created in the Azure Network Manager."
  type = list(object({
    connectivity_name     = string
    custom_name           = optional(string)
    connectivity_topology = optional(string)
    global_mesh_enabled   = optional(bool, false)
    deploy                = optional(bool, false)

    hub = optional(object({
      resource_id   = string
      resource_type = optional(string, "Microsoft.Network/virtualNetworks")
    }), null)

    applies_to_groups = list(object({
      network_group_name          = string
      direct_connectivity_enabled = optional(bool, false)
      global_mesh_enabled         = optional(bool, false)
      use_hub_gateway             = optional(bool, false)
    }))
  }))
  default  = []
  nullable = false
}

variable "security_admin_configurations" {
  description = "Security admin configurations to be created in the Azure Network Manager."

  type = list(object({
    sac_name            = string
    custom_name         = optional(string)
    description         = optional(string)
    apply_default_rules = optional(bool, true)
    deploy              = optional(bool, false)

    rule_collections = optional(list(object({
      name                = string
      description         = optional(string)
      network_group_names = list(string)
      rules = list(object({
        name                    = string
        description             = optional(string)
        action                  = string
        direction               = string
        priority                = number
        protocol                = string
        destination_port_ranges = list(string)
        source = list(object({
          address_prefix_type = string
          address_prefix      = string
        }))
        destinations = list(object({
          address_prefix_type = string
          address_prefix      = string
        }))
      }))
    })))
  }))
  default  = []
  nullable = false
}

variable "connectivity_deployment" {
  description = "Connectivity deployment configuration over `connectivity` created objects."
  type = object({
    configuration_names = optional(list(string), [])
    configuration_ids   = optional(list(string), [])
  })
  default = {}
}

variable "security_deployment" {
  description = "Security deployment configuration over `security_admin` created objects."
  type = object({
    configuration_names = optional(list(string), [])
    configuration_ids   = optional(list(string), [])
  })
  default = {}
}
