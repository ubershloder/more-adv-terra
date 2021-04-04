output "alb_dns_name" {
  value       = aws_elb.ELB.dns_name
  description = "Domain name of ELB"
}
output "RDS_addr" {
  value       = aws_db_instance.RDS.address
  description = "RDS adress"
}
output "RDS_port" {
  value       = aws_db_instance.RDS.port
  description = "RDS port"
}
