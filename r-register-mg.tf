resource "azapi_resource_action" "main" {
  for_each = toset(var.network_manager_scope.management_group_ids)

  type = "Microsoft.Management/managementGroups@2021-04-01"

  resource_id = each.value
  action      = "register"
}
