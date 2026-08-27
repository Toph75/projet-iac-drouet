.PHONY: bootstrap-init bootstrap-apply tf-init tf-plan tf-apply checkov

# Étape 1 (une seule fois) : crée le bucket S3 de state, en local state
bootstrap-init:
	cd bootstrap && terraform init

bootstrap-apply:
	cd bootstrap && terraform apply

# Étape 2 : init du projet principal avec le backend distant
# (copiez backend.hcl.example en backend.hcl avec le nom de bucket obtenu au bootstrap)
tf-init:
	terraform init -backend-config=backend.hcl

tf-plan:
	terraform plan -out=tfplan

tf-apply:
	terraform apply tfplan

checkov:
	checkov --config-file .checkov.yaml
