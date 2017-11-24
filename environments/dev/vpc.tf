
module "vpc" {
  # source = "git@github.com:cloudreach/awsloft-terraform-ci.git//modules/aws/network/vpc"
  source = "../../modules/aws/network/vpc"

  name = "${var.environment}"

  cidr = "10.20.0.0/16"

  azs                 = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets     = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
  public_subnets      = ["10.20.11.0/24", "10.20.12.0/24", "10.20.13.0/24"]
  database_subnets    = ["10.20.21.0/24", "10.20.22.0/24", "10.20.23.0/24"]


  enable_nat_gateway = false
  enable_s3_endpoint       = false
  enable_dynamodb_endpoint = false

  tags = {
    Owner       = "user"
    Environment = "${var.environment}"
    Scope = "aws-loft-de"
  }
}
