output "vpc" {
  description = "Main vpc"
  value = aws_vpc.main
}

output "subnet_public_a" {
  description = "Public subnet of availavitity zone A in main VPC. Has internet outbound."
  value = aws_subnet.public-a
}

output "subnet_public_c" {
  description = "Public subnet of availavitity zone C in main VPC. Has internet outbound."
  value = aws_subnet.public-c
}

output "subnet_public_ids" {
  description = "A list of public subnet's id. For unconsciously availavirity zone."
  value = [
    aws_subnet.public-a.id,
    aws_subnet.public-c.id
  ]
}

output "subnet_application_a" {
  description = "Application subnet of availavitity zone A in main VPC. Internet outbound creation is required, if you needed."
  value = aws_subnet.application-a
}

output "subnet_application_c" {
  description = "Application subnet of availavitity zone C in main VPC. Internet outbound creation is required, if you needed."
  value = aws_subnet.application-c
}

output "subnet_application_ids" {
  description = "A list of application subnet's id. For unconsciously availavirity zone."
  value = [
    aws_subnet.application-a.id,
    aws_subnet.application-c.id
  ]
}

output "subnet_database_a" {
  description = "Database subnet of availavitity zone A in main VPC. No internet outbound."
  value = aws_subnet.database-a
}

output "subnet_database_c" {
  description = "Database subnet of availavitity zone A in main VPC. No internet outbound."
  value = aws_subnet.database-c
}

output "subnet_database_ids" {
  description = "A list of database subnet's id. For unconsciously availavirity zone."
  value = [
    aws_subnet.database-a.id,
    aws_subnet.database-c.id
  ]
}

output "subnet_tooling" {
  description = "Tooling subnet of availavitity zone A. (availavitity zone A only)"
  value = aws_subnet.tooling
}
