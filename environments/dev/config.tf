
variable "region" {
  default     = "eu-central-1"
  description = "The region to deploy the cluster in, e.g: us-east-1."
}


variable "environment" {
  default     = "dev"
  description = "environment name"
}


terraform {
  required_version = ">= 0.10.5"
  backend "s3" {
    bucket = "aws-loft-de-terraform"
    key    = "dev/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true

  }
}

data "terraform_remote_state" "default" {
  backend = "s3"
  config {
    bucket = "aws-loft-de-terraform"
    key    = "dev/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
  }
}


# Define your AWS profile here
provider "aws" {
  region  = "eu-central-1"
  version = "~> 1.3.0"
}



data "aws_ssm_parameter" "db_username" {
  name  = "${var.environment}.db.username"
}

data "aws_ssm_parameter" "db_password" {
  name  = "${var.environment}.db.password"
}
