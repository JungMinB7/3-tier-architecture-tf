variable "name"                 { type = string }
variable "ami"                  { type = string }
variable "instance_type"        { type = string }
variable "subnet_id"            { type = string }
variable "security_group_ids"   { type = list(string), default = [] }
variable "key_name"             { type = string, default = null }
variable "iam_instance_profile" { type = string, default = null }
variable "associate_public_ip_address" { type = bool, default = false }

variable "user_data" {
  type        = string
  default     = ""
  description = "Cloud-init or shell script"
}

variable "root_block_device" {
  type = object({
    volume_size = optional(number)
    volume_type = optional(string)
    encrypted   = optional(bool)
  })
  default = null
}

variable "tags" { type = map(string), default = {} }
