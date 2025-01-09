variable "network_manager_scope" {
  description = <<-EOT
 - `management_group_ids` - (Optional) A list of management group IDs.
 - `subscription_ids` - (Optional) A list of subscription IDs.
EOT
  type = object({
    management_group_ids = optional(list(string), [])
    subscription_ids     = optional(list(string), [])
  })
  nullable = false
}

variable "network_manager_scope_accesses" {
  description = "A list of configuration deployment type. Possible values are `Connectivity` and `SecurityAdmin`, corresponds to if Connectivity Configuration and Security Admin Configuration is allowed for the Network Manager."
  type        = list(string)
  nullable    = false

  validation {
    condition     = alltrue([for s in var.network_manager_scope_accesses : contains(["Connectivity", "SecurityAdmin"], s)])
    error_message = "`var.network_manager_scope_accesses` must be a list of 'Connectivity' or 'SecurityAdmin' strings."
  }
}

variable "network_manager_description" {
  description = "A description of the Network Manager."
  type        = string
  default     = null
}

variable "network_manager_timeouts" {
  description = <<-EOT
 - `create` - (Defaults to 30 minutes) Used when creating the Network Managers.
 - `delete` - (Defaults to 30 minutes) Used when deleting the Network Managers.
 - `read` - (Defaults to 5 minutes) Used when retrieving the Network Managers.
 - `update` - (Defaults to 30 minutes) Used when updating the Network Managers.
EOT
  type = object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
  default = null
}
