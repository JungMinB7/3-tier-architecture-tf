locals {
  azs_sorted  = sort(keys(var.public_subnets_by_az))
  primary_az  = local.azs_sorted[0]
  nat_az_keys = var.single_nat_gateway ? [local.primary_az] : local.azs_sorted
}

resource "aws_eip" "nat" {
  for_each = toset(local.nat_az_keys)
  domain   = "vpc"
  tags     = merge(var.tags, { Name = "${var.name}-eip-${each.key}" })
}

resource "aws_nat_gateway" "this" {
  for_each      = toset(local.nat_az_keys)
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = var.public_subnets_by_az[each.key]
  tags          = merge(var.tags, { Name = "${var.name}-nat-${each.key}" })
}
