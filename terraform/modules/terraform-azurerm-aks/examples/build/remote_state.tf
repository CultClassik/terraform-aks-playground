# data "terraform_remote_state" "devtest_network" {
#   backend = "remote"
#   config = {
#     hostname     = "app.terraform.io"
#     organization = "Diehlabs"
#     workspaces = {
#       name = "aks-mgmt-networking-devtest"
#     }
#   }
# }
