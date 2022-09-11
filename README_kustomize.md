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
    * `kubectl apply -k ./k8s/argocd`
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