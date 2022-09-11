locals {

  # msi_obj_id = "fdd3f20b-18e3-4c89-a6e9-c4ddc2265616"

  tags_all = merge(
    var.tags,
    var.tags_extra
  )
  # subnet_list = {
  #   nonprod = {
  #     subnets = [
  #       {
  #         subnet_name = "aks-terratest"
  #         vnet_name   = data.terraform_remote_state.devtest_network.outputs.network.vnet.name
  #         properties = {
  #           addressPrefix = data.terraform_remote_state.devtest_network.outputs.network.cidr["terratest"]
  #           networkSecurityGroup = {
  #             id = data.terraform_remote_state.devtest_network.outputs.network.cidr["terratest"]
  #           }
  #           routeTable = {
  #             id = data.terraform_remote_state.devtest_network.outputs.network.cidr["terratest"]
  #           }
  #         }
  #       },
  #     ]
  #   },
  # }

}
