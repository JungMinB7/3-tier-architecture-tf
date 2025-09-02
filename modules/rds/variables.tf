variable "name"               { type = string }
variable "subnet_ids"         { type = list(string) }
variable "security_group_ids" { type = list(string), default = [] }

variable "engine_version"     { type = string, default = "8.0" }
variable "instance_class"     { type = string, default = "db.t3.micro" }
variable "allocated_storage"  { type = number, default = 20 }
variable "max_allocated_storage" { type = number, default = 100 }
variable "kms_key_id"         { type = string, default = null }

variable "master_username"    { type = string }
variable "master_password" {
  type        = string
  sensitive   = true
  description = "Use Secrets Manager/SSM in production"
}

variable "multi_az"              { type = bool,   default = false }
variable "backup_retention_days" { type = number, default = 7 }
variable "backup_window"         { type = string, default = "17:00-18:00" }
variable "maintenance_window"    { type = string, default = "sun:18:00-sun:19:00" }
variable "deletion_protection"   { type = bool,   default = true }
variable "skip_final_snapshot"   { type = bool,   default = false }
variable "apply_immediately"     { type = bool,   default = false }

variable "parameter_group_family" { type = string, default = null }
variable "parameters" {
  type    = list(object({ name = string, value = string }))
  default = []
}

variable "tags" { type = map(string), default = {} }
