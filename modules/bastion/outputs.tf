output "security_group" {
  description = "Bastion instance security group"
  value       = aws_security_group.bastion
}

output "instance_role" {
  description = "Bastion instance IAM Role"
  value       = aws_iam_role.bastion
}

output "instance" {
  description = "Bastion instance"
  value       = aws_instance.bastion
}
