locals {
  public_map  = zipmap(var.azs, var.public_cidrs)
  private_map = zipmap(var.azs, var.private_cidrs)
}

resource "aws_subnet" "public_subnet" {
  for_each                = local.public_map
  vpc_id                  = var.vpc_id
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.subnet_name}-public-${each.key}"
    Tier = "public"
  })
}

resource "aws_subnet" "private_subnet" {
  for_each                = local.private_map
  vpc_id                  = var.vpc_id
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.subnet_name}-private-${each.key}"
    Tier = "private"
  })
}
