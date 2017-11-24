output "www-record" {
  description = "public DNS"
  value       = "${aws_route53_record.www.fqdn}"
}
