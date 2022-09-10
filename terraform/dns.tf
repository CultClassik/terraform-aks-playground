data "azurerm_resource_group" "diehlabs_dns" {
  name = "diehlabs-dns"
}

data "azurerm_dns_zone" "diehlabs" {
  name                = "diehlabs.com"
  resource_group_name = data.azurerm_resource_group.diehlabs_dns.name
}

resource "azurerm_dns_a_record" "playground" {
  name                = "playground"
  zone_name           = data.azurerm_dns_zone.diehlabs.name
  resource_group_name = data.azurerm_resource_group.diehlabs_dns.name
  ttl                 = 300
  records             = [var.node_lb_ip]
}