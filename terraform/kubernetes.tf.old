provider "kubernetes" {
  host                   = "https://${module.aks_cluster.cluster_fqdn}:443"
  client_certificate     = base64decode(module.aks_cluster.kube_admin_client_certificate)
  client_key             = base64decode(module.aks_cluster.kube_admin_client_key)
  cluster_ca_certificate = base64decode(module.aks_cluster.kube_admin_cluster_ca_certificate)
}

resource "kubernetes_manifest" "bootstrap" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ConfigMap"
    "metadata" = {
      "name"      = "test-config"
      "namespace" = "default"
    }
    "data" = {
      "foo" = "bar"
    }
  }
  # depends_on = [
  #   local_file.kubeconfig
  # ]
}