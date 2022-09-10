terraform {
  required_version = ">= 1.1.0"
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.1"
    }
    # vault = {
    #   source  = "hashicorp/vault"
    #   version = "~> 3.6.0"
    # }
    # helm = {
    #   source  = "hashicorp/helm"
    #   version = "~> 2.5.0"
    # }

  }
}
