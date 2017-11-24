
# Output the ID of the RDS instance
output "rds_instance_id" {
  value = "${aws_db_instance.default.id}"
}

# Output the address (aka hostname) of the RDS instance
output "rds_instance_address" {
  value = "${aws_db_instance.default.address}"
}

# Output endpoint (hostname:port) of the RDS instance
output "rds_instance_endpoint" {
  value = "${aws_db_instance.default.endpoint}"
}
