# Azure Network Manager
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/network-manager/azurerm/)

Azure module to deploy a [Azure Network Manager](https://docs.microsoft.com/en-us/azure/xxxxxxx).

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
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
      network_group_name    = "mesh-global"
      connectivity_topology = "Mesh"
      global_mesh_enabled   = true
      applies_to_group = {
        group_connectivity  = "DirectlyConnected"
        global_mesh_enabled = true
      }
    },
    {
      connectivity_name     = "hubspoke-region-euw"
      deploy                = true
      network_group_name    = "hubspoke-euw"
      connectivity_topology = "HubAndSpoke"
      global_mesh_enabled   = false
      applies_to_group = {
        group_connectivity  = "None"
        global_mesh_enabled = false
        use_hub_gateway     = true
      }
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
```

## Providers

| Name | Version |
|------|---------|
| azapi | >= 2.0 |
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.63 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | ~> 7.0.0 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource_action.main](https://registry.terraform.io/providers/hashicorp/azapi/latest/docs/resources/resource_action) | resource |
| [azurerm_network_manager.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager) | resource |
| [azurerm_network_manager_admin_rule.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_admin_rule) | resource |
| [azurerm_network_manager_admin_rule_collection.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_admin_rule_collection) | resource |
| [azurerm_network_manager_connectivity_configuration.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_connectivity_configuration) | resource |
| [azurerm_network_manager_deployment.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_deployment) | resource |
| [azurerm_network_manager_deployment.security](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_deployment) | resource |
| [azurerm_network_manager_network_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_network_group) | resource |
| [azurerm_network_manager_security_admin_configuration.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_security_admin_configuration) | resource |
| [azurerm_network_manager_static_member.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_static_member) | resource |
| [azurecaf_name.network_manager](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.network_manager_connectivity_configuration](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.network_manager_group](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.network_manager_security_admin](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| connectivity\_configurations | Connectivity configurations to be created in the Azure Network Manager. | <pre>list(object({<br/>    connectivity_name     = string<br/>    network_group_name    = string<br/>    custom_name           = optional(string)<br/>    connectivity_topology = optional(string)<br/>    global_mesh_enabled   = optional(bool, false)<br/>    deploy                = optional(bool, false)<br/><br/>    hub = optional(object({<br/>      resource_id   = string<br/>      resource_type = optional(string, "Microsoft.Network/virtualNetworks")<br/>    }), null)<br/><br/>    applies_to_group = object({<br/>      group_connectivity  = optional(string, "None")<br/>      global_mesh_enabled = optional(bool, false)<br/>      use_hub_gateway     = optional(bool, false)<br/>    })<br/>  }))</pre> | `[]` | no |
| connectivity\_deployment | Connectivity deployment configuration over `connectivity` created objects. | <pre>object({<br/>    configuration_names = optional(list(string), [])<br/>    configuration_ids   = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_name | Custom Azure Network Manager, generated if not set | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Additional tags to add on resources. | `map(string)` | `{}` | no |
| location | Azure region to use. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| network\_groups | Network groups to be created in the Azure Network Manager. | <pre>list(object({<br/>    ng_name        = string<br/>    custom_name    = optional(string)<br/>    description    = optional(string)<br/>    member_type    = optional(string, "VirtualNetwork")<br/>    static_members = optional(list(string))<br/>  }))</pre> | `[]` | no |
| network\_manager\_description | A description of the Network Manager. | `string` | `null` | no |
| network\_manager\_scope | - `management_group_ids` - (Optional) A list of management group IDs.<br/>- `subscription_ids` - (Optional) A list of subscription IDs. | <pre>object({<br/>    management_group_ids = optional(list(string))<br/>    subscription_ids     = optional(list(string))<br/>  })</pre> | n/a | yes |
| network\_manager\_scope\_accesses | A list of configuration deployment type. Possible values are `Connectivity` and `SecurityAdmin`, corresponds to if Connectivity Configuration and Security Admin Configuration is allowed for the Network Manager. | `list(string)` | n/a | yes |
| network\_manager\_timeouts | - `create` - (Defaults to 30 minutes) Used when creating the Network Managers.<br/>- `delete` - (Defaults to 30 minutes) Used when deleting the Network Managers.<br/>- `read` - (Defaults to 5 minutes) Used when retrieving the Network Managers.<br/>- `update` - (Defaults to 30 minutes) Used when updating the Network Managers. | <pre>object({<br/>    create = optional(string)<br/>    delete = optional(string)<br/>    read   = optional(string)<br/>    update = optional(string)<br/>  })</pre> | `null` | no |
| resource\_group\_name | Name of the resource group. | `string` | n/a | yes |
| security\_admin\_configurations | Security admin configurations to be created in the Azure Network Manager. | <pre>list(object({<br/>    sac_name            = string<br/>    custom_name         = optional(string)<br/>    description         = optional(string)<br/>    apply_default_rules = optional(bool, true)<br/>    deploy              = optional(bool, false)<br/><br/>    rule_collections = optional(list(object({<br/>      name              = string<br/>      description       = optional(string)<br/>      network_group_ids = list(string)<br/>      rules = list(object({<br/>        name                    = string<br/>        description             = optional(string)<br/>        action                  = string<br/>        direction               = string<br/>        priority                = number<br/>        protocol                = string<br/>        destination_port_ranges = list(string)<br/>        source = list(object({<br/>          address_prefix_type = string<br/>          address_prefix      = string<br/>        }))<br/>        destinations = list(object({<br/>          address_prefix_type = string<br/>          address_prefix      = string<br/>        }))<br/>      }))<br/>    })))<br/>  }))</pre> | `[]` | no |
| security\_deployment | Security deployment configuration over `security_admin` created objects. | <pre>object({<br/>    configuration_names = optional(list(string), [])<br/>    configuration_ids   = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| stack | Project stack name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| connectivity\_configurations | connectivity configurations |
| id | Azure Network Manager ID. |
| name | Azure Network Manager name. |
| network\_manager | Azure Network Manager output object. |
| security\_configurations | security configurations |
| vnet\_network\_groups | network groups |
<!-- END_TF_DOCS -->

## Related documentation

Microsoft Azure documentation: xxxx
