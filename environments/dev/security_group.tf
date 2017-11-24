
module "wordpress_sg" {
  # source = "git@github.com:cloudreach/awsloft-terraform-ci.git//modules/aws/network/sg"
  source = "../../modules/aws/network/sg"

  name           = "wordpress-${var.environment}"
  vpc_id         = "${module.vpc.vpc_id}"

  web_white_list = ["0.0.0.0/0"]
  ssh_white_list = ["0.0.0.0/0"]

  tags = {
    Owner       = "user"
    Environment = "${var.environment}"
    Project     = "wordpress-cluster"
    Scope       = "aws-loft-de"
  }

}
