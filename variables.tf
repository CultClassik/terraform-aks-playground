variable "unique_id" {
  description = "The Azure Pipelines build ID"
  type        = string
}

variable "node_count" {
  description = "Number of cluster nodes"
  type        = number
}

variable "tags" {
  type = map(any)
}

variable "tags_extra" {
  type    = map(any)
  default = {}
}

variable "vm_size" {
  type = string
}

variable "auto_start_time" {
  description = "time for the automation runbook to start (shuts down aks cluster)"
  type = string  
}