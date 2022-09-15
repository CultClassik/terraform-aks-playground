#!/bin/bash

export KUBECONFIG=$(pwd)/../kubeconfig
export KM_PATH=$(pwd)../k8s/apps-manifests

kubectl apply -f "${KM_PATH}/istio/"
kubectl apply -k $(pwd)/../cluster-apps/
