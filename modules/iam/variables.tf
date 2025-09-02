variable "name"            { type = string }
variable "trust_services"  { type = list(string) } # ex) ["ec2.amazonaws.com"]
variable "managed_policy_arns" { type = list(string), default = [] }

variable "inline_policies" {
  type = list(object({
    name     = string
    document = string # IAM JSON
  }))
  default = []
}

variable "create_instance_profile" { type = bool, default = false }
variable "tags" { type = map(string), default = {} }
