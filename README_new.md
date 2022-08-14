```bash
# install argo-cd using the umbrella chart
export ARGO_NS=argocd
kubectl apply -f k8s/namespace
helm install argocd k8s/argocd --namespace "$ARGO_NS"

# install argo apps - argo will now manage itselfß
helm template k8s/apps/ --namespace "$ARGO_NS" | kubectl apply -f -

export ARGO_SVC=argocd-server &&\
kubectl patch svc "$ARGO_SVC" -n "$ARGO_NS" -p '{"spec": {"type": "LoadBalancer"}}'


```
