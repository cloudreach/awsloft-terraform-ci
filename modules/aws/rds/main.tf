resource "aws_db_subnet_group" "default" {
  name       = "${var.name}"
  description =  "${var.name}_subnet_group"
  subnet_ids = ["${var.db_subnet_ids}"]
}

resource "aws_db_instance" "default" {
  name                 = "${var.name}"
  identifier           = "${var.name}"
  allocated_storage    = "${var.allocated_storage}"
  storage_type         = "gp2"
  engine               = "${var.engine}"
  engine_version       = "${var.engine_version}"
  instance_class       = "${var.instance_class}"
  username             = "${var.username}"
  password             = "${var.password}"
  db_subnet_group_name = "${aws_db_subnet_group.default.id}"
  storage_encrypted    = "true"
  skip_final_snapshot  = true
  vpc_security_group_ids = ["${var.security_group}"]
  multi_az             = "${var.multi_az}"

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"

}
