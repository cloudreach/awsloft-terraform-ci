
module "vpc" {
  source = "../../modules/aws/network/vpc"

  name = "${var.environment}"

  cidr = "10.30.0.0/16"

  azs                 = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets     = ["10.30.1.0/24", "10.30.2.0/24", "10.30.3.0/24"]
  public_subnets      = ["10.30.11.0/24", "10.30.12.0/24", "10.30.13.0/24"]
  database_subnets    = ["10.30.21.0/24", "10.30.22.0/24", "10.30.23.0/24"]


  enable_nat_gateway = false
  enable_s3_endpoint       = false
  enable_dynamodb_endpoint = false

  tags = {
    Owner       = "user"
    Environment = "${var.environment}"
    Scope = "aws-loft-de"
  }
}
