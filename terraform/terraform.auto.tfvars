unique_id         = "001"
node_count_system = 1
vm_size_system    = "Standard_A2m_v2" #"Standard_B2s"
max_pods = 100
# node_count_worker = 2
# vm_size_worker    = "Standard_B2s" #"Standard_A2m_v2"

tags = {
  environment = "test"
  owner       = "Chris Diehl"
  product     = "aks-playground"
  location    = "eastus"
}

# auto_start_time = "2022-08-15T05:00:00Z"

# node_lb_ip = "52.154.152.222"