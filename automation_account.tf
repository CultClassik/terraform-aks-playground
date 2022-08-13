resource "azurerm_automation_runbook" "aks" {
  name                    = "shutdown-aks"
  location                = azurerm_resource_group.terratest.location
  resource_group_name     = azurerm_resource_group.terratest.name
  automation_account_name = azurerm_automation_account.aks.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "Turn off aks to save dough"
  runbook_type            = "PowerShellWorkflow"
  content                 = local.shutdown_script
}

resource "azurerm_automation_account" "aks" {
  name                = "aks-playground"
  location            = azurerm_resource_group.terratest.location
  resource_group_name = azurerm_resource_group.terratest.name
  sku_name            = "Basic"
  tags                = local.tags_all
}

locals {
  shutdown_script = <<EOT
Disable-AzContextAutosave –Scope Process
$connection = Get-AutomationConnection -Name AzureRunAsConnection
$logonAttempt = 0
while(!($connectionResult) -And ($logonAttempt -le 10))
{
    $LogonAttempt++
    # Logging in to Azure...
    $connectionResult =    Connect-AzAccount `
                               -ServicePrincipal `
                               -Tenant $connection.TenantID `
                               -ApplicationId $connection.ApplicationID `
                               -CertificateThumbprint $connection.CertificateThumbprint

    Start-Sleep -Seconds 1
}
Set-AzContext -SubscriptionId "${data.azurerm_client_config.current.subscription_id}"
Stop-AzAksCluster -ResourceGroupName ${azurerm_resource_group.terratest.name} -Name ${module.aks_cluster.cluster_name}
EOT
}

resource "azurerm_automation_schedule" "aks_shutdown" {
  name                    = "EveryDayMignight"
  resource_group_name     = azurerm_resource_group.terratest.name
  automation_account_name = azurerm_automation_account.aks.name
  frequency               = "Hour"
  interval                = 24
  start_time              = "2022-08-13T00:00:00-05:00"
  timezone                = "America/Chicago"
  description             = "Every Day at Midnight"
}

####################################################################################################
# SP for autmation account "runas"
####################################################################################################

resource "time_offset" "end_date" {
  offset_hours = 24 * 365
}

resource "random_string" "random" {
  length  = 16
  special = false
}

# resource "tls_private_key" "aks_automation" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# resource "local_file" "cert_pem" {
#   content  = tls_private_key.aks_automation.public_key_pem
#   filename = "${azuread_application.aks_automation.display_name}.pem"
# }

# resource "local_file" "key_pem" {
#   content  = tls_private_key.aks_automation.private_key_pem
#   filename = "${azuread_application.aks_automation.display_name}.key"
# }

# resource "null_resource" "cert_pfx" {
#   provisioner "local-exec" {
#     command = "openssl pkcs12 -export -keypbe NONE -certpbe NONE -inkey ${local_file.key_pem.filename} -in ${local_file.cert_pem.filename} -out ${azuread_application.aks_automation.display_name}.pfx"
#   }
#   depends_on = [
#     local_file.cert_pem,
#     local_file.key_pem,
#   ]
# }

resource "azuread_application" "aks_automation" {
  display_name = format("%s_%s", azurerm_automation_account.aks.name, random_string.random.result)
}

resource "azuread_application_certificate" "aks_automation" {
  application_object_id = azuread_application.aks_automation.id
  type                  = "AsymmetricX509Cert"
  end_date              = time_offset.end_date.rfc3339
  value                 = file("./certs/certificate.crt")
  #   value                 = tls_private_key.aks_automation.public_key_pem
}

resource "azuread_service_principal" "aks_automation" {
  application_id = azuread_application.aks_automation.application_id

  depends_on = [
    azuread_application_certificate.aks_automation,
  ]
}

resource "azuread_service_principal_certificate" "aks_automation" {
  service_principal_id = azuread_service_principal.aks_automation.id
  type                 = "AsymmetricX509Cert"
  value                = file("./certs/certificate.crt")
  end_date             = time_offset.end_date.rfc3339
  #   value                = tls_private_key.aks_automation.public_key_pem
}

resource "azurerm_role_assignment" "aks_automation" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aks_automation.object_id
}

resource "azurerm_automation_certificate" "aks_automation" {
  name                    = "AzureRunAsCertificate"
  resource_group_name     = azurerm_automation_account.aks.resource_group_name
  automation_account_name = azurerm_automation_account.aks.name
  base64                  = filebase64("./certs/certificate.pfx")
  #   base64                  = filebase64("${azuread_application.aks_automation.display_name}.pfx")
  #   depends_on              = [
  #     local_file.key_pem,
  #     local_file.cert_pem,
  #     null_resource.cert_pfx,
  #     ]
}

resource "azurerm_automation_connection_service_principal" "aks_automation" {
  name                    = "AzureRunAsConnection"
  resource_group_name     = azurerm_automation_account.aks.resource_group_name
  automation_account_name = azurerm_automation_account.aks.name
  application_id          = azuread_service_principal.aks_automation.application_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  subscription_id         = data.azurerm_client_config.current.subscription_id
  certificate_thumbprint  = azurerm_automation_certificate.aks_automation.thumbprint
}
