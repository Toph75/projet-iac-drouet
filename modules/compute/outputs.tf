output "instance_id" {
  description = "ID de l'instance créée"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Adresse IP privée de l'instance"
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "Adresse IP publique de l'instance (null si associate_public_ip = false)"
  value       = aws_instance.this.public_ip
}
