variable "subnet_name"   { type = string }
variable "vpc_id" { type = string }

variable "azs" {
  type        = list(string)
  description = "e.g., [\"ap-northeast-2a\",\"ap-northeast-2b\"]"
  validation {
    condition     = length(var.azs) > 0
    error_message = "At least one AZ is required."
  }
}

variable "public_cidrs" {
  type        = list(string)
  description = "Public CIDRs (same length/order as azs)"
  validation {
    condition     = length(var.public_cidrs) == length(var.azs)
    error_message = "public_cidrs length must equal azs length."
  }
}

variable "private_cidrs" {
  type        = list(string)
  description = "Private CIDRs (same length/order as azs)"
  validation {
    condition     = length(var.private_cidrs) == length(var.azs)
    error_message = "private_cidrs length must equal azs length."
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}
