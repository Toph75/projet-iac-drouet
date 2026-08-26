variable "aws_region" {
  description = "Région AWS de déploiement"
  type        = string
  default     = "eu-west-3" # Paris
}

variable "vpc_id" {
  description = "ID du VPC AWS"
  type        = string
}

variable "allowed_ssh_ip" {
  description = "Adresse IP autorisée pour le SSH au format CIDR" 
  type        = string
  default     = "127.0.0.1/32" # Par défaut : IP restreinte 
}