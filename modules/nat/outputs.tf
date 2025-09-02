output "nat_gateway_ids_by_az" {
  value = { for az, ngw in aws_nat_gateway.this : az => ngw.id }
}
