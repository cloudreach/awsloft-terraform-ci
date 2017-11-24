
// AMIs by region for AWS Optimised Linux
# data "aws_ami" "image" {
#   most_recent = true
#
#   owners = ["137112412989"]
#
#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }
#
#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }
#
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#
#   filter {
#     name   = "name"
#     values = ["amzn-ami-hvm-*"]
#   }
# }

# data "aws_ami" "image" {
#   most_recent = true
#   owners = ["099720109477"]
#
#   filter {
#       name   = "architecture"
#       values = ["x86_64"]
#     }
#
#   filter {
#     name = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
#   }
# }

data "template_file" "wordpress" {
  template = "${file("${path.module}/files/wordpress.sh")}"

  vars {
    region       = "${var.region}"
    efs_id       = "${var.efs_id}"
    environment  = "${var.environment}"
    db_username  = "${var.db_username}"
    db_password  = "${var.db_password}"
    db_name      = "${var.db_name}"
    db_host      = "${var.db_host}"
    environment         = "${var.environment}"
    route53_domain      = "${var.route53_domain}"

  }
}

//  Launch configuration for the cluster auto-scaling group.
resource "aws_launch_configuration" "wordpress-cluster-lc" {
  name_prefix          = "${var.environment}-wordpress-node-"
  image_id             = "${var.ami_id}"
  instance_type        = "${var.amisize}"
  user_data            = "${data.template_file.wordpress.rendered}"
  associate_public_ip_address = true
  iam_instance_profile = "${var.iam_instance_profile}"
  key_name             = "${var.key_name}"
  security_groups      = ["${var.ec2_sg}"]

  lifecycle {
    create_before_destroy = true
  }
}



# Application Load Balancer
resource "aws_alb" "alb" {
    name = "${var.environment}-wordpress-alb"
    internal = false
    security_groups = ["${var.elb_sg}"]
    subnets = ["${var.subnets}"]
    tags {
        Name = "${var.environment}-wordpress-alb"
        Environment = "${var.environment}"
    }
}

resource "aws_alb_target_group" "web" {
  name = "${var.environment}-wordpress-alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"

  health_check {
      healthy_threshold     = 2
      unhealthy_threshold   = 2
      timeout               = 3
      path                  = "/"
      matcher               = "200-299"
  }
  tags {
      Name = "${var.environment}-wordpress-alb-tg"
      Environment = "${var.environment}"
  }
}

resource "aws_alb_listener" "alb-http" {
   load_balancer_arn = "${aws_alb.alb.arn}"
   port = "80"
   protocol = "HTTP"

   default_action {
     target_group_arn = "${aws_alb_target_group.web.arn}"
     type = "forward"
   }
}


data "aws_route53_zone" "selected" {
  name         = "${var.route53_domain}."
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "www-${var.environment}.${var.route53_domain}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_alb.alb.dns_name}"]
}


resource "aws_ssm_parameter" "target_endpoint" {
  name  = "${var.environment}.www.target"
  type  = "String"
  # value = "${aws_alb.alb.dns_name}"
  value = "www-${var.environment}.${var.route53_domain}"
  overwrite = true
}

//  Auto-scaling group for our cluster.
resource "aws_autoscaling_group" "wordpress-cluster-asg" {
  depends_on           = ["aws_launch_configuration.wordpress-cluster-lc"]
  name                 = "${var.environment}-${var.asgname}"
  launch_configuration = "${aws_launch_configuration.wordpress-cluster-lc.name}"
  min_size             = "${var.min_size}"
  desired_capacity     = "${var.desired_capacity}"
  max_size             = "${var.max_size}"
  vpc_zone_identifier  = ["${var.subnets}"]
  target_group_arns    =   ["${aws_alb_target_group.web.arn}"]

  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  lifecycle {
    create_before_destroy = true
  }

  tags = ["${concat(
    list(
      map("key", "Name", "value", "${var.environment}-${var.asgname}", "propagate_at_launch", true)
    ),
    var.extra_tags)
  }"]

}
