output "security_group_id" {
  description = "ID du security group créé"
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "ARN du security group créé"
  value       = aws_security_group.this.arn
}
