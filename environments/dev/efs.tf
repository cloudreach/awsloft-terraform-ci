
module "wordpress_efs" {
  # source = "git@github.com:cloudreach/awsloft-terraform-ci.git//modules/aws/efs"
  source = "../../modules/aws/efs"

  name            = "wordpress-${var.environment}"
  security_groups = ["${module.wordpress_sg.efs_sg}"]
  subnets         = "${module.vpc.private_subnets}"

  tags = {
    Owner       = "user"
    Environment = "${var.environment}"
    Project     = "wordpress-cluster"
    Scope       = "aws-loft-de"
  }

}
