# https://learn.microsoft.com/en-us/azure/virtual-network-manager/concept-network-manager-scope#scope
# https://learn.microsoft.com/en-us/rest/api/resources/providers/register-at-management-group-scope?view=rest-resources-2021-04-01
resource "azapi_resource_action" "main" {
  for_each = toset(var.network_manager_scope.management_group_ids)

  type = "Microsoft.Management/managementGroups@2021-04-01"

  resource_id = each.value
  action      = "providers/Microsoft.Network/register"
}
