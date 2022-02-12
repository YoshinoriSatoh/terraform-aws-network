output "vpc" {
  description = "Main vpc"
  value       = aws_vpc.main
}

output "subnet_public_a" {
  description = "Public subnet of availavitity zone A in main VPC. Has internet outbound."
  value       = aws_subnet.public_a
}

output "subnet_public_c" {
  description = "Public subnet of availavitity zone C in main VPC. Has internet outbound."
  value       = aws_subnet.public_c
}

output "subnet_public_ids" {
  description = "A list of public subnet's id. For unconsciously availavirity zone."
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id
  ]
}

output "subnet_private_a" {
  description = "private subnet of availavitity zone A in main VPC. Internet outbound creation is required, if you needed."
  value       = aws_subnet.private_a
}

output "subnet_private_c" {
  description = "private subnet of availavitity zone C in main VPC. Internet outbound creation is required, if you needed."
  value       = aws_subnet.private_c
}

output "subnet_private_ids" {
  description = "A list of private subnet's id. For unconsciously availavirity zone."
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_c.id
  ]
}

output "db_subnet_group_main" {
  description = "main rds subnet group"
  value       = aws_db_subnet_group.main
}

output "aws_elasticache_subnet_group_main" {
  description = "main elasticache subnet group"
  value       = aws_elasticache_subnet_group.main
}

output "nat_instance_security_group" {
  description = "NAT instance security group"
  value       = var.nat_enabled ? module.nat_instance[0].security_group : null
}
