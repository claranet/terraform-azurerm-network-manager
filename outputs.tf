output "network_manager" {
  description = "Azure Network Manager output object."
  value       = azurerm_network_manager.main
}

output "id" {
  description = "Azure Network Manager ID."
  value       = azurerm_network_manager.main.id
}

output "name" {
  description = "Azure Network Manager name."
  value       = azurerm_network_manager.main.name
}


output "vnet_network_groups" {
  description = "network groups"
  value       = azurerm_network_manager_network_group.main
}

output "connectivity_configurations" {
  description = "connectivity configurations"
  value       = azurerm_network_manager_connectivity_configuration.main
}

output "security_configurations" {
  description = "security configurations"
  value       = azurerm_network_manager_security_admin_configuration.main
}
