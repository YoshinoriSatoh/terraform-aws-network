output "vpc" {
  description = "Main vpc"
  value = aws_vpc.main
}

output "subnet_public_a" {
  description = "Public subnet of availavitity zone A in main VPC. Has internet outbound."
  value = aws_subnet.public_a
}

output "subnet_public_c" {
  description = "Public subnet of availavitity zone C in main VPC. Has internet outbound."
  value = aws_subnet.public_c
}

output "subnet_public_ids" {
  description = "A list of public subnet's id. For unconsciously availavirity zone."
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id
  ]
}

output "subnet_application_a" {
  description = "Application subnet of availavitity zone A in main VPC. Internet outbound creation is required, if you needed."
  value = aws_subnet.application_a
}

output "subnet_application_c" {
  description = "Application subnet of availavitity zone C in main VPC. Internet outbound creation is required, if you needed."
  value = aws_subnet.application_c
}

output "subnet_application_ids" {
  description = "A list of application subnet's id. For unconsciously availavirity zone."
  value = [
    aws_subnet.application_a.id,
    aws_subnet.application_c.id
  ]
}

output "subnet_database_a" {
  description = "Database subnet of availavitity zone A in main VPC. No internet outbound."
  value = aws_subnet.database_a
}

output "subnet_database_c" {
  description = "Database subnet of availavitity zone A in main VPC. No internet outbound."
  value = aws_subnet.database_c
}

output "subnet_database_ids" {
  description = "A list of database subnet's id. For unconsciously availavirity zone."
  value = [
    aws_subnet.database_a.id,
    aws_subnet.database_c.id
  ]
}

output "subnet_tool" {
  description = "tool subnet of availavitity zone A. (availavitity zone A only)"
  value = aws_subnet.tool
}

output "db_subnet_group_main" {
  description = "main rds subnet group"
  value = aws_db_subnet_group.main
}

output "aws_elasticache_subnet_group_main" {
  description = "main elasticache subnet group"
  value = aws_elasticache_subnet_group.main
}
