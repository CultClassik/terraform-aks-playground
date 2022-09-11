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
2. Install cluster-apps
    * installs everything else and will manage argocd itself as well