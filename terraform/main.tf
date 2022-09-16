provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "terratest" {
  name     = "rg-aks-cluster-${var.unique_id}"
  location = var.tags.location
  tags     = local.tags_all
}

resource "tls_private_key" "aks" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_virtual_network" "terratest" {
  name                = "vnet-terratest-${var.unique_id}"
  location            = azurerm_resource_group.terratest.location
  resource_group_name = azurerm_resource_group.terratest.name
  address_space       = ["172.16.14.0/24"]
  tags                = local.tags_all
  depends_on = [
    azurerm_resource_group.terratest
  ]
}

resource "azurerm_subnet" "terratest" {
  name                 = "subnet-terratest-${var.unique_id}"
  resource_group_name  = azurerm_resource_group.terratest.name
  virtual_network_name = azurerm_virtual_network.terratest.name
  address_prefixes     = ["172.16.14.0/24"]
  depends_on = [
    azurerm_virtual_network.terratest
  ]
}

module "aks_cluster" {
  source                    = "./modules/terraform-azurerm-aks"
  resource_group_name       = azurerm_resource_group.terratest.name
  tags                      = local.tags
  tags_extra                = var.tags_extra
  subnet_id                 = azurerm_subnet.terratest.id
  docker_bridge_cidr        = "192.168.0.1/16"
  dns_service_ip            = "172.16.100.126"
  service_cidr              = "172.16.100.0/25"
  kubernetes_version_number = "1.24.0"
  location                  = var.tags.location
  max_pods                  = var.max_pods
  local_account_disabled    = false
  vm_size_system            = var.vm_size_system
  node_count_system         = var.node_count_system
  vm_size_worker            = var.vm_size_worker
  node_count_worker         = var.node_count_worker
  # msi_id            = var.msi_id #data.terraform_remote_state.devtest_infra.outputs.identity.id
  cluster_admin_ids = ["9ba4a348-227d-4411-bc37-3fb81ee8bc48"]
  # laws                = data.azurerm_log_analytics_workspace.example
  depends_on = [
    azurerm_resource_group.terratest,
    azurerm_subnet.terratest
  ]
}

# data "azuread_group" "kube_admins" {
#   display_name     = "kube_admins"
#   security_enabled = true
# }
