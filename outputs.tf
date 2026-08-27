

output "ec2_public_ip" {
  description = "Adresse IP publique de la VM applicative"
  value       = module.compute.public_ip
}



output "instance_id" {
  description = "ID de l'instance déployée"
  value       = module.compute.instance_id
}

output "security_group_id" {
  description = "ID du security group déployé"
  value       = module.security_group.security_group_id
}

output "vpc_id" {
  description = "ID du VPC créé"
  value       = module.network.vpc_id
}
