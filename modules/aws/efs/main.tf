resource "aws_efs_file_system" "efs" {
  creation_token = "${var.name}"
  performance_mode = "${var.performance_mode}"
  tags = "${merge(var.tags, map("Name", format("efs_%s", var.name)))}"
}

resource "aws_efs_mount_target" "efs" {
  # count = "${length(var.subnets)}"
  # Workaround mistake inside efs module https://github.com/terraform-providers/terraform-provider-aws/issues/1938
  count = "3"

  file_system_id  = "${aws_efs_file_system.efs.id}"
  subnet_id       = "${element(var.subnets, count.index)}"
  security_groups = ["${var.security_groups}"]
}
