output "security_group" {
  description = "NAT instance security group"
  value = aws_security_group.nat_instance
}

output "instance_role" {
  description = "NAT instance IAM Role"
  value = aws_iam_role.nat_instance
}

output "instance_a" {
  description = "NAT instance (AZ: A)"
  value = aws_instance.nat_a
}

output "instance_c" {
  description = "NAT instance (AZ: C only when multi AZ enabled)"
  value = var.multi_az ? aws_instance.nat_c : null
}