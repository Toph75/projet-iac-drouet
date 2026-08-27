variable "name" {
  description = "Nom de l'instance EC2"
  type        = string
}

variable "ami_id" {
  description = "ID de l'AMI à utiliser"
  type        = string
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "ID du subnet dans lequel lancer l'instance"
  type        = string
}

variable "security_group_ids" {
  description = "Liste des security groups à attacher à l'instance"
  type        = list(string)
}

variable "associate_public_ip" {
  description = "Associer une IP publique à l'instance (déconseillé, cf. CKV_AWS_88). Passez par un ALB/NAT à la place."
  type        = bool
  default     = false
}

variable "iam_instance_profile" {
  description = "Nom du profil IAM à attacher (recommandé, cf. CKV2_AWS_41). Laisser null seulement en test."
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Taille du volume racine en Go"
  type        = number
  default     = 20
}

variable "enable_termination_protection" {
  description = "Active la protection contre la suppression accidentelle (CKV_AWS_135 / bonne pratique prod)"
  type        = bool
  default     = false
}


variable "key_name" {
  type        = string
  description = "Nom de la paire de clés SSH"
  default     = "vockey"
}

variable "tags" {
  description = "Tags communs à appliquer sur la ressource"
  type        = map(string)
  default     = {}
}
