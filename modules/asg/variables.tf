variable "name"                 { type = string }
variable "ami"                  { type = string }
variable "instance_type"        { type = string }
variable "subnet_ids"           { type = list(string) }
variable "security_group_ids"   { type = list(string), default = [] }
variable "iam_instance_profile" { type = string, default = null }
variable "key_name"             { type = string, default = null }

# user_data는 base64 인코딩 형태 권장 (변경시 롤링)
variable "user_data_base64" {
  type        = string
  default     = null
  description = "Base64-encoded user_data. Use templatefile(...) |> base64encode(...)"
}

variable "root_block_device" {
  type = object({
    device_name = optional(string, "/dev/xvda")
    volume_size = optional(number, 20)
    volume_type = optional(string, "gp3")
    encrypted   = optional(bool, true)
  })
  default = null
}

variable "target_group_arns" { type = list(string), default = [] }

variable "desired_capacity" { type = number, default = 2 }
variable "min_size"         { type = number, default = 2 }
variable "max_size"         { type = number, default = 4 }

variable "health_check_type"         { type = string, default = "EC2" } # 또는 "ELB"
variable "health_check_grace_period" { type = number, default = 60 }
variable "termination_policies"      { type = list(string), default = ["OldestLaunchTemplate", "OldestInstance"] }

variable "enable_target_tracking" { type = bool,   default = true }
variable "cpu_target_value"       { type = number, default = 50 }

variable "wait_for_elb_capacity" { type = number, default = 0 }
variable "instance_maintenance_policy" {
  type = object({
    min_healthy_percentage = number
    max_healthy_percentage = number
  })
  default = null
}

variable "tags" { type = map(string), default = {} }
