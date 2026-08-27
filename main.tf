module "network" {
  source = "./modules/network"

  name              = "app"
  availability_zone = var.availability_zone

  tags = var.default_tags
}


module "security_group" {
  source = "./modules/security_group"

  name        = "app-sg"
  description = "Security group pour instance applicative"
  vpc_id      = module.network.vpc_id

  ingress_rules = [
    {
      description = "SSH depuis mon IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["82.96.161.255/32"] # <-- Remplacez par le résultat de curl ifconfig.me
    },
    {
      description = "HTTP depuis Internet"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = var.default_tags
}

module "compute" {
  source = "./modules/compute"

  name                 = "app-instance"
  ami_id               = var.ami_id
  subnet_id            = module.network.public_subnet_id # <-- Modifié : subnet public
  security_group_ids   = [module.security_group.security_group_id]
  associate_public_ip  = true                            # <-- Modifié : attribuer une IP publique
  iam_instance_profile = "LabInstanceProfile"
  key_name             = "vockey" # <-- OBLIGATOIRE pour AWS Learner Lab

  tags = var.default_tags
}