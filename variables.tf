variable "aws_region" {
  description = "Région AWS de déploiement"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "Zone de disponibilité pour le VPC créé"
  type        = string
  default     = "us-east-1a"
}

variable "ami_id" {
  description = "AMI à utiliser pour l'instance EC2"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR précis autorisé en SSH (jamais 0.0.0.0/0). Laissez null pour ne pas ouvrir le port 22 du tout et passer uniquement par SSM Session Manager (recommandé)."
  type        = string
  default     = null
}

variable "default_tags" {
  description = "Tags appliqués par défaut à toutes les ressources"
  type        = map(string)
  default = {
    Project     = "infra"
    ManagedBy   = "terraform"
    Environment = "dev"
  }
}
