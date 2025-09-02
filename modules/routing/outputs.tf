output "public_route_table_id" {
  description = "Route table ID for public subnets"
  value       = aws_route_table.public.id
}

output "private_route_table_ids_by_az" {
  description = "Map of AZ => private route table ID"
  value       = { for az, rt in aws_route_table.private : az => rt.id }
}