## Misc
```bash
# if not destroying the cluster don't forget to shut it down so you don't burn the monthly azure credit :/
az aks stop -n terratest-centralus-test -g rg-aks-terratest-0002

# and start it up when ready
az aks start -n terratest-centralus-test -g rg-aks-terratest-0002
```

## Components
* ArgoCD
* Cert-Manager / ACME
* Workload Identity
* Istio
* Kiali
* Vault

## Pre-reqs
* Execute `scripts/auto-acct-certs` once.
* Create resources with Terraform
```bash
terraform init

terraform plan

terraform apply -auto-approve

export KUBECONFG=$(pwd)/kubeconfig
```

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

## Argo CD
1. Install with Helm
2. K8S credentials?
3. Configure repo(s) to monitor

```bash
# Seet var for ns and create the ns, label it for istio injection
export ARGO_NS=argocd &&\
kubectl create ns "$ARGO_NS" &&\
kubectl label namespace "$ARGO_NS" istio-injection=enabled 

# install native k8s way - should do it with helm istead - see below
# kubectl apply -n "$ARGO_NS" -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

## need to use HA config for real-life use
helm repo add argo-cd https://argoproj.github.io/argo-helm &&\
helm dep update helm/argo-cd/ &&\
helm install argo-cd helm/argo-cd/ -n $ARGOCD_NS

# export ARGO_SVC=argocd-server
export ARGO_SVC=argo-cd-argocd-server
# patch the service - should be able to do this with helm...
kubectl patch svc "$ARGO_SVC" -n "$ARGO_NS" -p '{"spec": {"type": "LoadBalancer"}}'

# get the initial password for argo "admin" account
kubectl -n "$ARGO_NS" get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

# port forward, temporary access to argo ui
kubectl port-forward "svc/${ARGO_SVC}" -n "$ARGO_NS" 8080:443

# Now get the public IP of the kubernetes load balancer from the managed cluster resource group in Azure - view in browser, login with admin and the password from the secret above

```

## [Istio](https://istio.io/latest/docs/setup/install/helm/)
* https://istio.io/latest/docs/setup/platform-setup/azure/
```bash
# add helm repo to client
helm repo add istio https://istio-release.storage.googleapis.com/charts &&\
helm repo update

# set var for ns and create ns
istio_ns=istio-system &&\
kubectl create ns "$istio_ns"

# install base
helm install istio-base istio/base -n "$istio_ns"

# install discovery
helm install istiod istio/istiod -n "$istio_ns" --wait

# install ingress gateway
kubectl create namespace istio-ingress &&\
kubectl label namespace istio-ingress istio-injection=enabled &&\
helm install istio-ingress istio/gateway -n istio-ingress --wait


```

## Master Helm Chart aka aks-config
* See helm/aks-config/Chart.yaml