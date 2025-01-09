output "resource" {
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

output "resource_vnet_network_groups" {
  description = "Network groups resource objects."
  value       = azurerm_network_manager_network_group.main
}

output "resource_connectivity_configurations" {
  description = "Connectivity configurations resource objects."
  value       = azurerm_network_manager_connectivity_configuration.main
}

output "resource_security_configurations" {
  description = "Security configurations resource objects."
  value       = azurerm_network_manager_security_admin_configuration.main
}

output "module_diagnostics" {
  description = "Diagnostics settings module outputs."
  value       = module.diagnostics
}
