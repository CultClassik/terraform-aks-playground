variable "nsg_rules" {
  description = "The list of NSG rules to add to the NSG"
  # type        = object(any)
}

variable "nsg" {
  description = "The NSG object to manage rules for"
  type = object({
    name                = string
    resource_group_name = string
  })
}
