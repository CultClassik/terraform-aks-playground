#!/bin/sh

ns_name=argocd

kubectl create namespace "$ns_name"

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl patch svc argocd-server --patch-file ./argocd-server-type-patch.yaml -n "$ns_name"

echo "UI IP address and ports:"
kubectl get svc -n argocd argocd-server -o=json | jq -C '.status.loadBalancer.ingress'
kubectl get svc -n argocd argocd-server -o=json | jq -C '.spec.ports'

# k get svc -n argocd argocd-server -o=jsonpath='{.spec.type}'

# change the ClusterIP to a LoadBalancer for the argo-server to access the UI for testing