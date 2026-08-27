resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  monitoring                  = true # CKV_AWS_126 : monitoring détaillé
  ebs_optimized                = true # CKV_AWS_135 : optimisation EBS
  disable_api_termination     = var.enable_termination_protection

  metadata_options {
    http_tokens                 = "required" # CKV_AWS_79 : force IMDSv2
    http_endpoint                = "enabled"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    encrypted   = true # CKV_AWS_8 : chiffrement du volume racine
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }


 

  tags = merge(var.tags, {
    Name = var.name
  })
}
