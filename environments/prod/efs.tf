
module "wordpress_efs" {
  source = "../../modules/aws/efs"

  name            = "wordpress-${var.environment}"
  security_groups = ["${module.wordpress_sg.efs_sg}"]
  subnets         = "${module.vpc.private_subnets}"
  performance_mode = "maxIO"

  tags = {
    Owner       = "user"
    Environment = "${var.environment}"
    Project     = "wordpress-cluster"
    Scope       = "aws-loft-de"
  }

}
