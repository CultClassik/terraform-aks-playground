output "nsg_rules" {
  value = local.nsg_rules[var.resource_type]
}
