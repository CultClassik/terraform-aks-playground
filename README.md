This example is used for automated testing of this module.

Example of using the Vault provider to pull in secrets used for automated testing:
```hcl
provider "vault" {
  address = "https://vaultcm.diehlabs.com:443"
  auth_login {
    path = "auth/approle/login"
    parameters = {
      role_id   = var.vault_approle_id
      secret_id = var.vault_approle_secret
    }
  }
}

data "vault_generic_secret" "az_spn_svc_tfe_ccoe_devtest" {
  path = "stratos/prod/az_spn_svc_tfe_ccoe_devtest"
}

provider "azurerm" {
  features {}
  subscription_id = data.vault_generic_secret.az_spn_svc_tfe_ccoe_devtest.data.subscription_id
  client_id = data.vault_generic_secret.az_spn_svc_tfe_ccoe_devtest.data.client_id
  client_secret = data.vault_generic_secret.az_spn_svc_tfe_ccoe_devtest.data.client_secret
  tenant_id = data.vault_generic_secret.az_spn_svc_tfe_ccoe_devtest.data.tenant_id
}
```
