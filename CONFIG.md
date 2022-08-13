## Workload Identity

1. Enable ODIC issuer with Terraform param on aks resource `odic_issuer_enabled = true` (there's also a az cli command if the cluster was not created with TF)
2. [Configure AKS Preview Feature - OIDC issuer](https://docs.microsoft.com/en-us/azure/aks/cluster-configuration#oidc-issuer-preview)
```bash
# install az aks ext
az extension add --name k8s-extension
# or upgrade it
az extension update --name k8s-extension

# Install the aks-preview extension
az extension add --name aks-preview
# or update it
az extension update --name aks-preview

# enablethe preview feature for the current azure subscription
az feature register --name EnableOIDCIssuerPreview --namespace Microsoft.ContainerService

# status
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/EnableOIDCIssuerPreview')].{Name:name,State:properties.state}"

# once status is registered - propogate
az provider register -n Microsoft.ContainerService

# get the odic issuer url and save it for later
az aks show -n terratest-centralus-test -g rg-aks-terratest-0002 --query "oidcIssuerProfile.issuerUrl" -otsv
# ex: https://oidc.prod-aks.azure.com/cb8928f4-2fa3-4241-980a-fdc5d3468b19/
```
3. [Install workload-identity-webhook chart](https://azure.github.io/azure-workload-identity/docs/installation/mutating-admission-webhook.html#helm-3-recommended)
```bash
helm repo add azure-workload-identity https://azure.github.io/azure-workload-identity/charts
helm repo update
helm install workload-identity-webhook azure-workload-identity/workload-identity-webhook \
   --namespace azure-workload-identity-system \
   --create-namespace \
   --set azureTenantID="${ARM_TENANT_ID}"
```


```bash
# if not destroying the cluster don't forget to shut it down so you don't burn the monthly azure credit :/
az aks stop -n terratest-centralus-test -g rg-aks-terratest-0002

# and start it up when ready
az aks start -n terratest-centralus-test -g rg-aks-terratest-0002
```