resource "aws_security_group" "elb_sg" {
  name        = "elb_${var.name}"
  description = "elb_${var.name}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.web_white_list}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.web_white_list}"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  tags = "${merge(var.tags, map("Name", format("elb_%s", var.name)))}"

}


resource "aws_security_group" "ec2_sg" {
  name        = "ec2_${var.name}"
  description = "ec2_${var.name}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.elb_sg.id}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh_white_list}"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  tags = "${merge(var.tags, map("Name", format("ec2_%s", var.name)))}"
}



resource "aws_security_group" "rds_sg" {
  name        = "rds_${var.name}"
  description = "rds_${var.name}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = ["${aws_security_group.ec2_sg.id}"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  tags = "${merge(var.tags, map("Name", format("rds_%s", var.name)))}"
}

resource "aws_security_group" "efs_sg" {
  name        = "efs_${var.name}"
  description = "efs_${var.name}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = ["${aws_security_group.ec2_sg.id}"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  tags = "${merge(var.tags, map("Name", format("efs_%s", var.name)))}"
}
