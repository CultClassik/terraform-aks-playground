variable "unique_id" {
  description = "The Azure Pipelines build ID"
  type        = string
}

variable "rg_name" {
  description = "The name of the resource group to create"
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
  type = map(any)
}
