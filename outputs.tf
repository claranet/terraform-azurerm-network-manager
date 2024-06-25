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
