variable "aws_region" {
  description = "Région AWS où créer le bucket de state"
  type        = string
  default     = "eu-west-3"
}

variable "project_name" {
  description = "Nom du projet, utilisé pour préfixer le bucket de state"
  type        = string
  default     = "app"
}

variable "tags" {
  description = "Tags communs"
  type        = map(string)
  default = {
    Project   = "infra"
    ManagedBy = "terraform-bootstrap"
  }
}
