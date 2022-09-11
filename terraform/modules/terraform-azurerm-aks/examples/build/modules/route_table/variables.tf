variable "tags" {
  description = "Tag information to be assigned to resources created."
  type = object({
    product           = string
    cost_center       = string
    environment       = string
    location          = string
    owner             = string
    technical_contact = string
  })
}

variable "name" {
  description = "The name of the route table to create"
  type        = string
}

variable "vnet" {
  description = "The VNET object containing the subnet for the route table"
  type = object({
    resource_group_name = string
  })
}

variable "routes" {
  description = "List of routes to create for the route table"
  # type        = object(any)
}
