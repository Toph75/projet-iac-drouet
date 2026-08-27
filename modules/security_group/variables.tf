variable "name" {
  description = "Nom du security group"
  type        = string
}

variable "description" {
  description = "Description du security group (requis par Checkov CKV_AWS_23 : pas de description vide/générique)"
  type        = string
}

variable "vpc_id" {
  description = "ID du VPC dans lequel créer le security group"
  type        = string
}

variable "ingress_rules" {
  description = "Règles d'entrée. Chaque règle doit avoir une description explicite (CKV_AWS_23)."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    # Bloque explicitement l'ouverture de SSH (22) et RDP (3389) au monde entier
    # -> couvre CKV_AWS_24, CKV_AWS_25, CKV_AWS_260
    condition = alltrue([
      for rule in var.ingress_rules :
      !(
        contains(rule.cidr_blocks, "0.0.0.0/0") &&
        (
          (rule.from_port <= 22 && rule.to_port >= 22) ||
          (rule.from_port <= 3389 && rule.to_port >= 3389)
        )
      )
    ])
    error_message = "Interdit : ouverture du port 22 (SSH) ou 3389 (RDP) sur 0.0.0.0/0. Restreignez le cidr_blocks à des IP/ranges précis."
  }
}

variable "egress_rules" {
  description = "Règles de sortie"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [{
    description = "Autoriser tout le trafic sortant"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "tags" {
  description = "Tags communs à appliquer sur la ressource"
  type        = map(string)
  default     = {}
}
