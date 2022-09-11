output "ssh_private_key" {
  description = "The auto generated ssh private key for the cluster"
  sensitive   = true
  value       = tls_private_key.aks.private_key_pem
}

output "kube_admin_config" {
  description = "The kube admin config file"
  sensitive   = true
  value       = module.aks_cluster.kube_admin_config
}

output "cluster_name" {
  description = "The auto-generated cluster name"
  value       = module.aks_cluster.cluster_name
}

output "kube_admin_password" {
  value     = module.aks_cluster.kube_admin_password
  sensitive = true
}

output "kube_admin_client_certificate" {
  value     = module.aks_cluster.kube_admin_client_certificate
  sensitive = true
}

output "kube_admin_client_key" {
  value     = module.aks_cluster.kube_admin_client_key
  sensitive = true
}

output "kube_admin_cluster_ca_certificate" {
  value     = module.aks_cluster.kube_admin_cluster_ca_certificate
  sensitive = true
}