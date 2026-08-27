output "vpc_id" {
  description = "ID du VPC créé"
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "ID du subnet public"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID du subnet privé (à utiliser pour les instances applicatives)"
  value       = aws_subnet.private.id
}

output "nat_gateway_id" {
  description = "ID de la NAT Gateway"
  value       = aws_nat_gateway.this.id
}
