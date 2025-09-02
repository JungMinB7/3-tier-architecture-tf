variable "name"   { type = string }
variable "public_subnets_by_az" {
  type        = map(string) # az => public subnet id
  description = "Map of AZ to PUBLIC subnet ID"
}
variable "single_nat_gateway" {
  type        = bool
  default     = false
}
variable "tags" { type = map(string), default = {} }

