provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  # Nom globalement unique sans dépendre d'un provider random :
  # compte + région suffisent à garantir l'unicité.
  state_bucket_name   = "${var.project_name}-tfstate-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  logging_bucket_name = "${var.project_name}-tfstate-logs-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
}

# --- Clé KMS dédiée au chiffrement du bucket de state ---
resource "aws_kms_key" "state" {
  description         = "Clé KMS pour chiffrer le bucket de state Terraform"
  enable_key_rotation = true # CKV_AWS_7

  # Policy explicite requise par CKV2_AWS_64 : sans ce bloc, AWS applique
  # une policy par défaut invisible pour l'analyse statique.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnableRootAccountFullAccess"
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
        Action    = "kms:*"
        Resource  = "*"
      },
      {
        Sid       = "AllowS3ServiceUseOfTheKey"
        Effect    = "Allow"
        Principal = { Service = "s3.amazonaws.com" }
        Action = [
          "kms:GenerateDataKey*",
          "kms:Decrypt"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_kms_alias" "state" {
  name          = "alias/${var.project_name}-tfstate"
  target_key_id = aws_kms_key.state.key_id
}

# --- Bucket cible pour les access logs (requis par CKV_AWS_18 sur le bucket principal) ---
# NB : CKV_AWS_144 (réplication cross-région) et CKV2_AWS_5/62 (attachement/notifications)
# sont déclarés en exception dans .checkov.yaml, pas ici (les commentaires inline
# ne sont pas fiables pour les checks graphés CKV2_*).
resource "aws_s3_bucket" "logs" {
  bucket = local.logging_bucket_name
  #checkov:skip=CKV_AWS_18:bucket de logs lui-même, pas de cible de log récursive nécessaire

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.state.arn
    }
    bucket_key_enabled = true
  }
}

# CKV2_AWS_61 : lifecycle configuration obligatoire, même sur un bucket de logs
resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "expire-old-logs"
    status = "Enabled"

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }

  rule {
    id     = "abort-incomplete-multipart-upload"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# CKV2_AWS_62 : notifications d'événements activées via EventBridge (pas de
# SNS/SQS/Lambda dédiés nécessaires pour une infra simple)
resource "aws_s3_bucket_notification" "logs" {
  bucket      = aws_s3_bucket.logs.id
  eventbridge = true
}

# --- Bucket principal : state Terraform ---
resource "aws_s3_bucket" "state" {
  bucket = local.state_bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true # CKV2_AWS_6
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled" # CKV_AWS_21
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms" # CKV_AWS_19 / CKV_AWS_145
      kms_master_key_id = aws_kms_key.state.arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_logging" "state" {
  bucket = aws_s3_bucket.state.id

  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "state-access-logs/"
}

resource "aws_s3_bucket_lifecycle_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }

  # CKV_AWS_300 : purge les uploads multipart jamais terminés
  rule {
    id     = "abort-incomplete-multipart-upload"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# CKV2_AWS_62 : notifications d'événements activées via EventBridge
resource "aws_s3_bucket_notification" "state" {
  bucket      = aws_s3_bucket.state.id
  eventbridge = true
}

# Interdit tout accès en clair (HTTP) au bucket de state
resource "aws_s3_bucket_policy" "state_force_tls" {
  bucket = aws_s3_bucket.state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "DenyInsecureTransport"
      Effect    = "Deny"
      Principal = "*"
      Action    = "s3:*"
      Resource = [
        aws_s3_bucket.state.arn,
        "${aws_s3_bucket.state.arn}/*"
      ]
      Condition = {
        Bool = {
          "aws:SecureTransport" = "false"
        }
      }
    }]
  })
}
