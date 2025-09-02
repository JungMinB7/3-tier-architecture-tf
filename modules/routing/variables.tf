variable "name"  { type = string }
variable "vpc_id"{ type = string }
variable "igw_id"{ type = string }

variable "public_subnets_by_az"  { type = map(string) }
variable "private_subnets_by_az" { type = map(string) }

variable "nat_gateway_ids_by_az" {
  type        = map(string)
  description = "Map of AZ => NAT GW ID. If single_nat_gateway=true, primary AZ's NAT is used by all."
}

variable "single_nat_gateway" { type = bool, default = false }
variable "tags"               { type = map(string), default = {} }
