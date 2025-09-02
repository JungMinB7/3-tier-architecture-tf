output "public_subnets_by_az" {
  value = { for az, s in aws_subnet.public_subnet : az => s.id }
}

output "private_subnets_by_az" {
  value = { for az, s in aws_subnet.private_subnet : az => s.id }
}

output "public_subnet_ids"  { value = [for s in aws_subnet.public_subnet  : s.id] }
output "private_subnet_ids" { value = [for s in aws_subnet.private_subnet : s.id] }
