variable "allocated_storage" {
  default = 20
  type = "string"
}

variable "security_group" {
  type = "list"
}

variable "engine" {
  default = "mysql"
  type    = "string"
}

variable "engine_version" {
  type    = "string"
}

variable "instance_class" {
  type    = "string"
  default = "db.t2.medium"
}

variable "username" {
  type    = "string"
}

variable "password" {
  type    = "string"
}

variable "db_subnet_ids" {
  type    = "list"
}

variable "name" {
  type = "string"
}

variable "multi_az" {
  type    = "string"
  default = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
