# terraform-azurerm-aks
[![Terraform Module CI](https://github.com/Diehlabs/terraform-azurerm-aks/actions/workflows/terraform-module-ci.yml/badge.svg)](https://github.com/Diehlabs/terraform-azurerm-aks/actions/workflows/terraform-module-ci.yml)

A basic AKS cluster module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.99.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_user_assigned_identity.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_admin_ids"></a> [cluster\_admin\_ids](#input\_cluster\_admin\_ids) | A list of Azure AD ObjectIDs that will receive admin rights to the cluster. | `list(any)` | n/a | yes |
| <a name="input_create_msi"></a> [create\_msi](#input\_create\_msi) | Create a unique MSI for this cluster | `bool` | `true` | no |
| <a name="input_dns_service_ip"></a> [dns\_service\_ip](#input\_dns\_service\_ip) | IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_docker_bridge_cidr"></a> [docker\_bridge\_cidr](#input\_docker\_bridge\_cidr) | IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_kubernetes_version_number"></a> [kubernetes\_version\_number](#input\_kubernetes\_version\_number) | Kubernetes cluster version number | `string` | n/a | yes |
| <a name="input_linux_profile"></a> [linux\_profile](#input\_linux\_profile) | User name and SSH public key for the admin account on cluster hosts. | <pre>object({<br>    username = string,<br>    sshkey   = string<br>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location for creating resources | `string` | n/a | yes |
| <a name="input_max_pods"></a> [max\_pods](#input\_max\_pods) | Max pods per node. 1 IP address reserved per (this value x number of nodes) | `number` | `30` | no |
| <a name="input_msi_ids"></a> [msi\_ids](#input\_msi\_ids) | List of optional MSI IDs to assign to the cluster | `list(string)` | `[]` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | Number of nodes in cluster | `string` | n/a | yes |
| <a name="input_node_pool_type"></a> [node\_pool\_type](#input\_node\_pool\_type) | The node pool type for the AKS cluster | `string` | `"VirtualMachineScaleSets"` | no |
| <a name="input_orchestrator_version"></a> [orchestrator\_version](#input\_orchestrator\_version) | The version of Kubernetes to install on nodes | `string` | `null` | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | OS disk size for AKS cluster nodes | `number` | `30` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. Defaults to false. Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | variable "spn\_id" {} variable "spn\_secret" {} | `any` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) the resource group object to create resources in.<br>  One will be created if none is provided. | <pre>object({<br>    name     = string<br>    location = string<br>  })</pre> | <pre>{<br>  "location": null,<br>  "name": null<br>}</pre> | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group to create the cluster in | `string` | n/a | yes |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | The Network Range used by the Kubernetes service. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID for the subnet the cluster will be placed in | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tag information to be assigned to resources created. | <pre>object({<br>    product     = string<br>    product_id  = string<br>    environment = string<br>    location    = string<br>    owner       = string<br>  })</pre> | n/a | yes |
| <a name="input_tags_extra"></a> [tags\_extra](#input\_tags\_extra) | Optional extra tag information to be assigned to resources created. | `map(any)` | `{}` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | VM size for AKS cluster nodes | `string` | `"Standard_DS3_v2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | n/a |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | n/a |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | n/a |
| <a name="output_cluster_fqdn"></a> [cluster\_fqdn](#output\_cluster\_fqdn) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_cluster_password"></a> [cluster\_password](#output\_cluster\_password) | n/a |
| <a name="output_cluster_username"></a> [cluster\_username](#output\_cluster\_username) | n/a |
| <a name="output_host"></a> [host](#output\_host) | n/a |
| <a name="output_kube_admin_client_certificate"></a> [kube\_admin\_client\_certificate](#output\_kube\_admin\_client\_certificate) | n/a |
| <a name="output_kube_admin_client_key"></a> [kube\_admin\_client\_key](#output\_kube\_admin\_client\_key) | n/a |
| <a name="output_kube_admin_cluster_ca_certificate"></a> [kube\_admin\_cluster\_ca\_certificate](#output\_kube\_admin\_cluster\_ca\_certificate) | n/a |
| <a name="output_kube_admin_config"></a> [kube\_admin\_config](#output\_kube\_admin\_config) | n/a |
| <a name="output_kube_admin_password"></a> [kube\_admin\_password](#output\_kube\_admin\_password) | n/a |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | n/a |
| <a name="output_kubelet_identity"></a> [kubelet\_identity](#output\_kubelet\_identity) | n/a |
<!-- END_TF_DOCS -->
