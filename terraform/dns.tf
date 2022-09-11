resource "azurerm_dns_zone" "aks" {
  name                = "aks.diehlabs.com"
  resource_group_name = azurerm_resource_group.terratest.name
}