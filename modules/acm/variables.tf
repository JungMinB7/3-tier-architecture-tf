variable "domain_name" { type = string }
variable "san"         { type = list(string), default = [] }
variable "zone_id"     { type = string }
variable "tags"        { type = map(string), default = {} }
