#!/bin/sh

my_path=$(pwd)
ISTIO_NS=istio-system
ISTIO_INGRESS_NS=istio-ingress
cd ..


## istio
helm repo add istio https://istio-release.storage.googleapis.com/charts &&\
helm repo update

# isito base/core and istiod
helm install istio-base istio/base -n "$ISTIO_NS" --create-namespace &&\
helm install istiod istio/istiod -n "$ISTIO_NS" --wait

# istio ingress gateway
kubectl create namespace "$ISTIO_INGRESS_NS" &&\
kubectl label namespace "$ISTIO_INGRESS_NS" istio-injection=enabled &&\
helm install istio-ingress istio/gateway -n "$ISTIO_INGRESS_NS" --wait

export INGRESS_HOST=$(kubectl -n "$ISTIO_INGRESS_NS" get service istio-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}') &&\
export INGRESS_PORT=$(kubectl -n "$ISTIO_INGRESS_NS" get service istio-ingress -o jsonpath='{.spec.ports[?(@.name=="http2")].port}') &&\
export SECURE_INGRESS_PORT=$(kubectl -n "$ISTIO_INGRESS_NS" get service istio-ingress -o jsonpath='{.spec.ports[?(@.name=="https")].port}') &&\
export TCP_INGRESS_PORT=$(kubectl -n "$ISTIO_INGRESS_NS" get service istio-ingress -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}')
