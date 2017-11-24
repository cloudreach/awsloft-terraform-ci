
variable "name" {
  type = "string"
  description = "(Required) The reference_name of your file system. Also, used in tags."
}

variable "subnets" {
  type = "list"
  description = "(Required) A comma separated list of subnet ids where mount targets will be."
}

variable "security_groups" {
  type = "list"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "performance_mode" {
  type = "string"
  description = "(Optional) The file system performance mode. Can be either generalPurpose/maxIO "
  default = "generalPurpose"
}
