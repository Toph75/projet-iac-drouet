output "instance_profile_name" {
  description = "Nom du profil d'instance à attacher à l'EC2"
  value       = aws_iam_instance_profile.ec2.name
}

output "role_arn" {
  description = "ARN du rôle IAM de l'instance"
  value       = aws_iam_role.ec2.arn
}
