

data "aws_ssm_parameter" "base_ami" {
  name  = "common.base_ami"
}

data "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "webapp-instance-profile"
}

module "wordpress-cluster" {
  source          = "../../modules/aws/ec2/autoscaling"
  region          = "${var.region}"
  amisize         = "t2.large"
  min_size         = "1"
  desired_capacity = "4"
  max_size         = "6"

  ami_id          = "${data.aws_ssm_parameter.base_ami.value}"

  environment     = "${var.environment}"
  vpc_id          = "${module.vpc.vpc_id}"
  subnets         = "${module.vpc.public_subnets}"
  ec2_sg          = ["${module.wordpress_sg.ec2_sg}"]
  elb_sg          = ["${module.wordpress_sg.elb_sg}"]
  efs_id          = "${module.wordpress_efs.efs_id}"

  db_username = "${data.aws_ssm_parameter.db_username.value}"
  db_password = "${data.aws_ssm_parameter.db_password.value}"
  db_name = "${module.wordpress_rds.rds_instance_id}"
  db_host = "${module.wordpress_rds.rds_instance_address}"

  iam_instance_profile  = "${data.aws_iam_instance_profile.ec2_instance_profile.name}"
  key_name        = "wordpress-cluster"
  asgname         = "wordpress-asg"

  extra_tags = [
    {
      key = "Environment"
      value = "${var.environment}"
      propagate_at_launch = true
    },
    {
      key = "Scope"
      value = "aws-loft-de"
      propagate_at_launch = true
    }
  ]
}


output "www-record" {
  description = "public DNS"
  value       = "${module.wordpress-cluster.www-record}"
}
