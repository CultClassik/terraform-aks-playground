# output "client_key" {
#   value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
#   sensitive = true
# }

# output "client_certificate" {
#   value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
#   sensitive = true
# }

# output "cluster_ca_certificate" {
#   value     = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
#   sensitive = true
# }

# output "cluster_username" {
#   value = azurerm_kubernetes_cluster.aks.kube_config.0.username
# }

# output "cluster_password" {
#   value     = azurerm_kubernetes_cluster.aks.kube_config.0.password
#   sensitive = true
# }

# output "kube_config" {
#   value     = azurerm_kubernetes_cluster.aks.kube_config_raw
#   sensitive = true
# }

# output "host" {
#   value     = azurerm_kubernetes_cluster.aks.kube_config.0.host
#   sensitive = true
# }

output "kube_admin_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive = true
}

output "kube_admin_password" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config.0.password
  sensitive = true
}

output "kube_admin_client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate
  sensitive = true
}

output "kube_admin_client_key" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key
  sensitive = true
}

output "kube_admin_cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config.0.cluster_ca_certificate
  sensitive = true
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "cluster_fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

output "kubelet_identity" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity
}
