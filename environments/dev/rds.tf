


module "wordpress_rds" {
  # source = "git@github.com:cloudreach/awsloft-terraform-ci.git//modules/aws/rds"
  source = "../../modules/aws/rds"
  name = "wordpress${var.environment}"

  security_group = ["${module.wordpress_sg.rds_sg}"]
  db_subnet_ids = "${module.vpc.database_subnets}"
  allocated_storage = 20
  engine = "mysql"
  engine_version = "5.7.19"
  instance_class = "db.t2.medium"
  username = "${data.aws_ssm_parameter.db_username.value}"
  password = "${data.aws_ssm_parameter.db_password.value}"
  multi_az = false

  tags = {
    Owner       = "user"
    Environment = "${var.environment}"
    Scope = "aws-loft-de"
  }

}
