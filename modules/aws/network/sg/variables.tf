variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "ssh_white_list" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "web_white_list" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "vpc_id" {
  type    = "string"
}
