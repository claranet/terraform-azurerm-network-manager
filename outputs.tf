output "network_manager" {
  description = "Azure Network Manager output object"
  value       = azurerm_network_manager.network_manager
}

output "id" {
  description = "Azure Network Manager ID"
  value       = azurerm_network_manager.network_manager.id
}

output "name" {
  description = "Azure Network Manager name"
  value       = azurerm_network_manager.network_manager.name
}

output "identity_principal_id" {
  description = "Azure Network Manager system identity principal ID"
  value       = try(azurerm_network_manager.network_manager.identity[0].principal_id, null)
}
