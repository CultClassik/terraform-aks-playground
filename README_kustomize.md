Bootstrapping:
1. istio
    * create gateway
2. cert-manager
    * create clusterissuer
    * create certificate for (hostname)
3. argo-cd
    * create vs for argocd ui
    * install argocd
4. cluster-apps
    * install apps from k8s/cluster-apps for argocd
    * from there argocd will manage everything including itself

## or?
1. Install argocd
    ```bash
    helm repo add
    helm template argo-cd/argo-cd --values ./values.yaml
    ```
    * `kubectl apply -k ./k8s/apps-manifests/argocd`

2. Install External-DNS
    ```bash
    # https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/azure.md
    # https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/istio.md
    cat <<-EOF > ./secret/azure.json
    {
    "tenantId": "${ARM_TENANT_ID}",
    "subscriptionId": "${ARM_SUBSCRIPTION_ID}",
    "resourceGroup": "rg-aks-terratest-002",
    "aadClientId": "${ARM_CLIENT_ID}",
    "aadClientSecret": "${ARM_CLIENT_SECRET}"
    }
    EOF

    # note the azure RG name that contains the dns one is located in some of these files
    kubectl create ns external-dns

    kubectl create secret generic azure-config-file --namespace external-dns --from-file ./secret/azure.json

    kubectl apply -k ./k8s/apps-manifests/external-dns
    ```
2. Install cluster-apps
    * Installs everything else and will manage argocd itself as well
    * Configure k8s secret for cert manager, see below
        ```bash
        # namespace would normally be created by argocd
        kubectl create ns cert-manager

        # the secret should normally be stored in vault and created by argocd
        kubectl create secret generic azuredns-config \
            -n cert-manager \
            --from-literal=client-secret=$ARM_CLIENT_SECRET
        ```
    * `kubectl apply -k ./k8s/cluster-apps`
3. Monitoring bootstrap and troubleshooting
    * Can't access UI thru istio yet!
    ```bash
    # get the initial password for "admin" in argocd
    kubectl get secret argocd-initial-admin-secret \
        -n argocd \
        -o jsonpath="{.data.password}" | base64 -d; echo

    # port forward to access the argocd ui at http://localhost:8080/argocd/
    kubectl port-forward svc/argocd-server \
        -n argocd 8080:443


    ```


```yaml
# Create the cert-manager namespace since it won't exist yet
# k8s/namespace/cert-manager.yaml
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: null
  name: cert-manager
spec: {}
status: {}
# The cluster issuer requires a k8s secret for the spn client secret
# create ahead of time for now, later use vault
apiVersion: v1
kind: Secret
metadata:
  name: azuredns-config
  namespace: cert-manager
type: Opaque
data:
  client-secret: <base64 encoded spn client secret>
```

## Get the Istio gateway info
```bash
NS_INGRESS=istio-ingress &&\
export INGRESS_HOST=$(kubectl -n "$NS_INGRESS" get service istio-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}') &&\
export INGRESS_PORT=$(kubectl -n "$NS_INGRESS" get service istio-ingress -o jsonpath='{.spec.ports[?(@.name=="http2")].port}') &&\
export SECURE_INGRESS_PORT=$(kubectl -n "$NS_INGRESS" get service istio-ingress -o jsonpath='{.spec.ports[?(@.name=="https")].port}') &&\
export TCP_INGRESS_PORT=$(kubectl -n "$NS_INGRESS" get service istio-ingress -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}') &&\
echo "INGRESS_HOST: $INGRESS_HOST" &&\
echo "INGRESS_PORT: $INGRESS_PORT" &&\
echo "SECURE_INGRESS_PORT: $SECURE_INGRESS_PORT" &&\
echo "TCP_INGRESS_PORT: $TCP_INGRESS_PORT"
```