
output "elb_sg" {
  description = "ELB SG ID"
  value       = "${aws_security_group.elb_sg.id}"
}

output "ec2_sg" {
  description = "EC2 SG ID"
  value       = "${aws_security_group.ec2_sg.id}"
}

output "rds_sg" {
  description = "RDS SG ID"
  value       = "${aws_security_group.rds_sg.id}"
}

output "efs_sg" {
  description = "EFS SG ID"
  value       = "${aws_security_group.efs_sg.id}"
}
