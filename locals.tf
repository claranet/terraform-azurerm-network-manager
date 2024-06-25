locals {
  scope_subscriptions_ids = [
    for sub in try(var.network_manager_scope.subscription_ids, []) : startswith(sub, "/subscriptions/") ? sub : "/subscriptions/${sub}"
  ]
}
