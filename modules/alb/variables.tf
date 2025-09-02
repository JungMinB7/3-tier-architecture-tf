variable "name"               { type = string }
variable "vpc_id"             { type = string }
variable "subnet_ids"         { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "target_group_port"  { type = number }
variable "target_type"        { type = string, default = "instance" } # "instance" or "ip"

variable "deletion_protection" { type = bool,   default = true }
variable "idle_timeout"        { type = number, default = 60 }
variable "redirect_to_https"   { type = bool,   default = true }
variable "certificate_arn"     { type = string, default = null }

variable "health_check" {
  type = object({
    path                = optional(string)
    interval            = optional(number)
    timeout             = optional(number)
    healthy_threshold   = optional(number)
    unhealthy_threshold = optional(number)
    matcher             = optional(string)
  })
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
