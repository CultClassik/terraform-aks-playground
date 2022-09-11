#!/bin/sh

# exported items cause terratest to skip that stage
 export SKIP_terraform_deploy=true

 export SKIP_run_tests=true

 export SKIP_terraform_redeploy=false

# export SKIP_terraform_destroy=true

go test -v -timeout 25m
