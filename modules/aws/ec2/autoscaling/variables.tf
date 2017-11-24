variable "region" {
  description = "The region to deploy the cluster in, e.g: us-east-1."
}

variable "amisize" {
  description = "The size of the cluster nodes, e.g: t2.micro"
}

variable "min_size" {
  description = "The minimum size of the cluter, e.g. 5"
}

variable "desired_capacity" {
  description = "The desired_capacity of the cluter, e.g. 5"
}

variable "max_size" {
  description = "The maximum size of the cluter, e.g. 5"
}

variable "environment" {
  description = "environment Name"
}

variable "ami_id" {
  description = "AMI Id"
}

variable "vpc_id" {
  description = "VPC Id"
}

variable "route53_domain" {
  description = "route53_domain"
  default = "aws-loft.cloudreach.com"
}


variable "key_name" {
  description = "The name of the key to user for ssh access, e.g: wordpress-cluster"
}


variable "asgname" {
  description = "The auto-scaling group name, e.g: wordpress-asg"
}

variable "iam_instance_profile" {
  description = "IAM profile"
}

variable "efs_id" {
  description = "EFS Id"
}

variable "subnets" {
  description = "A list of subnets inside the VPC"
  default     = []
}

variable "ec2_sg" {
  description = "A list of security_groups"
  default     = []
}

variable "elb_sg" {
  description = "A list of security_groups"
  default     = []
}

variable "extra_tags" {
  type = "list"
}

variable "db_username" {
  description = "RDS username"
}
variable "db_password" {
  description = "RDS password"
}
variable "db_name" {
  description = "RDS name"
}
variable "db_host" {
  description = "RDS address"
}
