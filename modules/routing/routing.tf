locals {
  azs_sorted = sort(keys(var.public_subnets_by_az))
  primary_az = local.azs_sorted[0]
}

# Public RT → IGW
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = var.public_subnets_by_az
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

# Private RT per AZ → NAT(싱글이면 primary NAT로)
resource "aws_route_table" "private" {
  for_each = var.private_subnets_by_az
  vpc_id   = var.vpc_id
  tags     = merge(var.tags, { Name = "${var.name}-private-rt-${each.key}" })
}

resource "aws_route" "private_default" {
  for_each               = var.private_subnets_by_az
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = var.single_nat_gateway
    ? var.nat_gateway_ids_by_az[local.primary_az]
    : var.nat_gateway_ids_by_az[each.key]
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = var.private_subnets_by_az
  subnet_id      = each.value
  route_table_id = aws_route_table.private[each.key].id
}
