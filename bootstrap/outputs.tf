output "state_bucket_name" {
  description = "Nom du bucket S3 à utiliser comme backend Terraform (voir versions.tf racine)"
  value       = aws_s3_bucket.state.id
}

output "state_bucket_arn" {
  description = "ARN du bucket de state"
  value       = aws_s3_bucket.state.arn
}

output "kms_key_arn" {
  description = "ARN de la clé KMS utilisée pour chiffrer le state"
  value       = aws_kms_key.state.arn
}
