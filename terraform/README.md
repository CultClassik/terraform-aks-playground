This Terraform code will:
* Create an AKS cluster
* Create a DNS subzone for AKS to use
* Generate a admin kubeconfig file in the parent directory
* Create an automation account and necessary resources to shut the cluster down nightly for money savings (needs work, possibly replace timestamp with a time provider resource, goal is to obtain a timestamp of a specific time, like 11:30 PM of TODAY)

State is stored in Terraform Cloud.
