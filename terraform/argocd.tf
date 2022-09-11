provider "kubernetes" {
#   client_certificate     = module.aks_cluster.kube_admin_client_certificate
#   client_key             = module.aks_cluster.kube_admin_client_key
#   cluster_ca_certificate = module.aks_cluster.kube_admin_cluster_ca_certificate
config_path = "../kubeconfig"
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
}