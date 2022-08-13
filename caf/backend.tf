terraform {
  cloud {
    organization = "Diehlabs"

    workspaces {
      name = "iac-azure-caf"
    }
  }
}