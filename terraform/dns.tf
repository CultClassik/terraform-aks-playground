resource "azurerm_resource_group" "aks_dns_nonprod" {
  name     = "diehlabs-dns-nonprod"
  location = local.tags.location
  tags     = local.tags_all
}

resource "azurerm_dns_zone" "aksnp_diehlabs_com" {
  resource_group_name = azurerm_resource_group.aks_dns_nonprod.name
  name                = "aksnp.diehlabs.com"
  tags                = local.tags_all
}

## delegate dns for the subzone
data "azurerm_dns_zone" "diehlabs_com" {
  name                = "diehlabs.com"
  resource_group_name = "diehlabs-dns"
}

resource "azurerm_dns_ns_record" "aksnp_diehlabs_com" {
  name                = "aksnp"
  zone_name           = data.azurerm_dns_zone.diehlabs_com.name
  resource_group_name = data.azurerm_dns_zone.diehlabs_com.resource_group_name
  ttl                 = 300
  records             = azurerm_dns_zone.aksnp_diehlabs_com.name_servers
  tags                = local.tags_all
}

# grant rights to k8s node msi for dns
resource "azurerm_role_assignment" "dns" {
  scope                = azurerm_resource_group.aks_dns_nonprod.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = module.aks_cluster.kubelet_identity[0].object_id
}