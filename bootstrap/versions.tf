terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Volontairement PAS de backend S3 ici : ce projet crée le bucket
  # qui servira de backend au reste de l'infra. Le state de ce
  # dossier reste local (terraform.tfstate), à conserver précieusement
  # (ou à migrer manuellement une fois le bucket créé si vous préférez).
}
