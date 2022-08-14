```bash
# 1. pre-create all required namespaces
# 2. install argo-cd using the umbrella chart
export ARGO_NS=argocd &&\
kubectl apply -f k8s/namespace &&\
helm install argocd k8s/argocd --namespace "$ARGO_NS"

# get the initial password for argo "admin" account
kubectl -n "$ARGO_NS" get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

# port forward for temp access to argo ui
# browse to localhost:8080
# use "admin" and the password obtained above
export ARGO_SVC=argocd-server &&\
kubectl port-forward "svc/${ARGO_SVC}" -n "$ARGO_NS" 8080:443

# install our apps to argo - argo will now manage itself
helm template k8s/apps/ --namespace "$ARGO_NS" | kubectl apply -f -

# once argo-cd is synced, ensure helm no longer manages our umbrella chart
# argo will now generate the manifests from the helm template and manage everything for us
kubectl delete secret -l owner=helm -n "$ARGO_NS"

```

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm install my-release argo/argo-rollouts
```