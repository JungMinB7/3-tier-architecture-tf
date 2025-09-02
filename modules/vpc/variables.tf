variable "name" {
  type        = string
  description = "VPC Name tag"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR (e.g., 10.0.0.0/16)"
  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "cidr_block must be a valid CIDR."
  }
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Enable DNS support"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Enable DNS hostnames"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Extra tags"
}
