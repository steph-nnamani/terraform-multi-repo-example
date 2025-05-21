
output "primary_address" {
  value       = module.mysql_primary.address
  description = "Connect to the primary database at this endpoint"
}

output "primary_port" {
  value       = module.mysql_primary.port
  description = "The primary database port"
}

output "primary_arn" {
    value       = module.mysql_primary.arn
    description = "The primary database arn"
}

