output "network_manager" {
  description = "Azure Network Manager output object."
  value       = azurerm_network_manager.this
}

output "id" {
  description = "Azure Network Manager ID."
  value       = azurerm_network_manager.this.id
}

output "name" {
  description = "Azure Network Manager name."
  value       = azurerm_network_manager.this.name
}


output "vnet_network_groups" {
  description = "network groups"
  value       = azurerm_network_manager_network_group.vnet
}

output "connectivity_configurations" {
  description = "connectivity configurations"
  value       = azurerm_network_manager_connectivity_configuration.this
}

output "security_configurations" {
  description = "security configurations"
  value       = azurerm_network_manager_security_admin_configuration.this
}
