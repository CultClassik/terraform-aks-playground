locals {
  dns_prefix = replace(lower("${var.tags.product}-${var.tags.environment}"), " ", "_")

  cluster_name = replace(lower("${var.tags.product}-${var.tags.location}-${var.tags.environment}"), " ", "_")

  identity_name = format("%s-identity", local.cluster_name)

  # identity_id = var.identity_id == null ? azurerm_user_assigned_identity.aks[0].id : var.identity_id

  # identity_object_id  = var.identity_id == null ? azurerm_user_assigned_identity.aks[0].principal_id : var.identity_id

  resource_group_name = var.resource_group.name == null ? "aks-${var.tags.product}" : var.resource_group.name

  orchestrator_version = var.orchestrator_version == null ? var.kubernetes_version_number : var.orchestrator_version

  # -----------------------------------------------------------------------------
  # Assemble required and optional tags into a single set of tags to be
  # assigned to Azure resources.
  # -----------------------------------------------------------------------------
  all_tags = merge(
    var.tags_extra,
    var.tags
  )

}
