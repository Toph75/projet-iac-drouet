variable "name" {
  description = "Préfixe de nom pour les ressources réseau"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloc CIDR du VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Bloc CIDR du subnet public (pour la NAT Gateway)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Bloc CIDR du subnet privé (pour les instances applicatives)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Zone de disponibilité utilisée pour les subnets"
  type        = string
}

variable "flow_log_retention_days" {
  description = "Durée de rétention des logs VPC Flow Logs (CKV_AWS_338 recommande >= 365 jours)"
  type        = number
  default     = 365
}

variable "tags" {
  description = "Tags communs"
  type        = map(string)
  default     = {}
}
