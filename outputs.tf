output "ssh_private_key" {
  description = "The auto generated ssh private key for the cluster"
  sensitive   = true
  value       = tls_private_key.example.private_key_pem
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
