terraform {
  backend "remote" {
    organization = "Diehlabs"

    workspaces {
      name = "terraform-aks-playground"
    }
  }
}