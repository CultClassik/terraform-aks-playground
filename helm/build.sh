#!/bin/sh
ns_name=argocd
cd ..
helm repo add argo-cd https://argoproj.github.io/argo-helm
helm dep update helm/argo-cd/
helm install argo-cd helm/argo-cd/ -n $ns_name --create-namespace