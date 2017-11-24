
variable "region" {
  default     = "eu-central-1"
  description = "The region to deploy the cluster in, e.g: us-east-1."
}



terraform {
  required_version = ">= 0.10.5"
  backend "s3" {
    bucket = "aws-loft-de-terraform"
    key    = "iam/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true

  }
}

data "terraform_remote_state" "default" {
  backend = "s3"
  config {
    bucket = "aws-loft-de-terraform"
    key    = "iam/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
  }
}


# Define your AWS profile here
provider "aws" {
  region  = "eu-central-1"
  version = "~> 0.1.4"
}
