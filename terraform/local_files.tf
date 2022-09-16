# resource "local_file" "ssh_private_key" {
#   content         = tls_private_key.aks.private_key_pem
#   filename        = "adminuser_rsa.key"
#   file_permission = "0600"
# }

resource "local_file" "kubeconfig" {
  content         = module.aks_cluster.kube_admin_config
  filename        = "../secret/kubeconfig"
  file_permission = "0600"
  depends_on = [
    module.aks_cluster
  ]
}

resource "local_file" "external_dns_config" {
  content = jsonencode({
    tenantId                    = data.azurerm_client_config.current.tenant_id
    subscriptionId              = data.azurerm_client_config.current.subscription_id
    resourceGroup               = resource.azurerm_resource_group.terratest.name
    useManagedIdentityExtension = true
  })
  filename        = "../secret/azure.json"
  file_permission = "0600"
  depends_on = [
    module.aks_cluster
  ]
}

resource "local_file" "env_vars" {
  content = <<EOT
RG_NAME="${azurerm_resource_group.terratest.name}"
DNS_RG_NAME="${azurerm_resource_group.aks_dns_nonprod.name}"
DNS_ZONE_NAME="${azurerm_dns_zone.aksnp_diehlabs_com.name}"
CLUSTER_NAME="${module.aks_cluster.cluster_fqdn}"
MSI_ID="${module.aks_cluster.kubelet_identity[0].client_id}"
EOT
  filename        = "../secret/env"
  file_permission = "0600"
  depends_on = [
    module.aks_cluster
  ]
}