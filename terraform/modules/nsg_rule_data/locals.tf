locals {
  allowed_access = [
    # ip addresses here
  ]

  nsg_rules = {
    aks = {
      allow_tcp_443_inbound = {
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefixes    = local.allowed_access
        destination_address_prefix = "*"
      }
      allow_tcp_443_to_artifactory = {
        priority                   = 250
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefixes    = local.allowed_access
        destination_address_prefix = "*"
      }
      deny_tcp_10250_inbound = {
        priority                   = 500
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "10250"
        source_address_prefixes    = local.allowed_access
        destination_address_prefix = "*"
      }
      deny_tcp_10255_inbound = {
        priority                   = 510
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "10255"
        source_address_prefixes    = local.allowed_access
        destination_address_prefix = "*"
      }
    }
  }
}
