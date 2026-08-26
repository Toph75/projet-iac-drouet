provider "aws" {
  region = var.aws_region
}

# Groupe de sécurité (Fail-Safe Default : sans règles déclarées, tout le trafic entrant est bloqué)
resource "aws_security_group" "web_sg" {
  name        = "app-web-sg"
  description = "Groupe de securite pour serveur web"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "app-web-sg"
    Environment = "education"
  }
}

# Règle entrante HTTP (Ouverte)
resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
  description       = "Autorise HTTP public"
}

# Règle entrante SSH (Restreinte - Défense en profondeur)
resource "aws_security_group_rule" "ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_ssh_ip]
  security_group_id = aws_security_group.web_sg.id
  description       = "Autorise SSH depuis IP spécifique"
}

# Règle sortante globale (Trafic sortant autorise)
resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # Tous les protocoles
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
  description       = "Trafic sortant autorise"
}