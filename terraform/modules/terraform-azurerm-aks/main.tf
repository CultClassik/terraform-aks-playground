resource "azurerm_user_assigned_identity" "aks" {
  count               = var.create_msi ? 1 : 0
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = local.identity_name
}

resource "azurerm_kubernetes_cluster" "aks" {
  azure_policy_enabled              = false
  http_application_routing_enabled  = false
  kubernetes_version                = var.kubernetes_version_number
  location                          = var.location
  name                              = local.cluster_name
  dns_prefix                        = "diehl"
  private_cluster_enabled           = false
  resource_group_name               = var.resource_group_name
  role_based_access_control_enabled = true
  tags                              = local.all_tags
  oidc_issuer_enabled               = true

  # dns_prefix_private_cluster       = local.dns_prefix
  # private_dns_zone_id               = var.private_dns_zone_id
  # dns_prefix is required if not a private cluster

  default_node_pool {
    name                 = "nodes"
    tags                 = local.all_tags
    node_count           = var.node_count
    vm_size              = var.vm_size
    os_disk_size_gb      = var.os_disk_size_gb
    vnet_subnet_id       = var.subnet_id
    type                 = var.node_pool_type
    max_pods             = var.max_pods
    orchestrator_version = local.orchestrator_version
  }

  identity {
    type = "UserAssigned"
    identity_ids = var.create_msi == false ? var.msi_ids : concat(
      var.msi_ids,
      [azurerm_user_assigned_identity.aks[0].id],
    )
  }


  # make this optional based on new - var.local_account_disabled ?
  # linux_profile {
  #   admin_username = var.linux_profile.username
  #   ssh_key {
  #     key_data = var.linux_profile.sshkey
  #   }
  # }

  local_account_disabled = var.local_account_disabled

  network_profile {
    network_plugin     = "kubenet"
    network_policy     = "calico"
    load_balancer_sku  = "standard"
    docker_bridge_cidr = var.docker_bridge_cidr
    dns_service_ip     = var.dns_service_ip
    service_cidr       = var.service_cidr
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = var.cluster_admin_ids
    azure_rbac_enabled     = true
  }

}

# resource "azurerm_kubernetes_cluster_node_pool" "default" {
#   name                  = "default"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
#   vm_size               = var.vm_size
#   node_count            = var.node_count
#   max_pods        = var.max_pods
#   enable_auto_scaling   = false
#   enable_node_public_ip = false
#   tags = local.all_tags
# }

# https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks
# resource "azurerm_log_analytics_solution" "aks" {
#   solution_name         = "ContainerInsights"
#   location              = var.laws.location
#   workspace_resource_id = var.laws.id
#   workspace_name        = var.laws.name
#   resource_group_name   = var.resource_group.name

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/ContainerInsights"
#   }
# }
