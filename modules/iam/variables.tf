variable "name" {
  description = "Nom du rôle / profil IAM pour l'instance"
  type        = string
}

variable "tags" {
  description = "Tags communs"
  type        = map(string)
  default     = {}
}
