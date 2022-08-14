#!/bin/sh

# ns_name=argocd

# kubectl apply -f ./ns-argocd.yaml

# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# kubectl patch svc argocd-server --patch-file ./argocd-server-type-patch.yaml -n "$ns_name"

# echo "UI IP address and ports:"
# kubectl get svc -n argocd argocd-server -o=json | jq -C '.status.loadBalancer.ingress'
# kubectl get svc -n argocd argocd-server -o=json | jq -C '.spec.ports'

# k get svc -n argocd argocd-server -o=jsonpath='{.spec.type}'

# change the ClusterIP to a LoadBalancer for the argo-server to access the UI for testing

my_path=$(pwd)
ARGOCD_NS=argocd
cd ../..

## argocd
## need to use HA config for real-life use
helm repo add argo-cd https://argoproj.github.io/argo-helm
helm dep update helm/argo-cd/
kubectl apply -f "${my_path}/ns-argocd.yaml"
helm install argo-cd helm/argo-cd/ -n $ARGOCD_NS