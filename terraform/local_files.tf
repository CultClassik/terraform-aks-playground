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
  filename        = "../secret/ext-dns-azure.json"
  file_permission = "0600"
  depends_on = [
    module.aks_cluster
  ]
}

resource "local_file" "env_vars" {
  content = <<EOT
RG_NAME=${resource.azurerm_resource_group.terratest.name}
CLUSTER_NAME=${rg-aks-cluster-001}
EOT
  filename        = "../secret/env"
  file_permission = "0600"
  depends_on = [
    module.aks_cluster
  ]
}