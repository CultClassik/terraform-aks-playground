variable "unique_id" {
  description = "The Azure Pipelines build ID"
  type        = string
}

variable "node_count_system" {
  description = "Number of cluster nodes"
  type        = number
}

variable "node_count_worker" {
  description = "Number of cluster nodes"
  type        = number
  default     = 0
}

variable "tags" {
  type = map(any)
}

variable "tags_extra" {
  type    = map(any)
  default = {}
}

variable "vm_size_system" {
  type = string
}

variable "vm_size_worker" {
  type    = string
  default = null
}

# variable "auto_start_time" {
#   description = "time for the automation runbook to start (shuts down aks cluster)"
#   type        = string
# }

# variable "node_lb_ip" {
#   description = "IP of the LB created by AKS for the nodepool"
#   default     = null
# }

variable "max_pods" {
  type = number
}