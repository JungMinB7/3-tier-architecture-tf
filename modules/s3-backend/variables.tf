variable "bucket_name"     { type = string }
variable "lock_table_name" { type = string }
variable "kms_key_id"      { type = string, default = null }
variable "force_destroy"   { type = bool,   default = false }
variable "lifecycle_enabled" { type = bool, default = true }
variable "tags"            { type = map(string), default = {} }
