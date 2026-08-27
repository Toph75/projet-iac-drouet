# Déploiement — compte AWS vierge

## Étape 0 — Pré-requis
- Un compte AWS avec des credentials configurés (`aws configure` ou variables d'env `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`).
- Terraform >= 1.6, Checkov (`pip install checkov`).

## Étape 1 — Bootstrap (une seule fois)
Crée le bucket S3 chiffré/versionné qui contiendra le state Terraform du reste de l'infra.

```bash
make bootstrap-init
make bootstrap-apply
```

Notez la valeur de l'output `state_bucket_name`.

## Étape 2 — Backend
Copiez `backend.hcl.example` en `backend.hcl` et renseignez le bucket obtenu :

```bash
cp backend.hcl.example backend.hcl
# éditez backend.hcl avec le vrai nom de bucket
```

## Étape 3 — Variables
```bash
cp terraform.tfvars.example terraform.tfvars
# éditez terraform.tfvars (region, AZ, AMI...)
```

## Étape 4 — Init / Plan / Apply
```bash
make tf-init
make tf-plan
make tf-apply
```

## Étape 5 — Scan de sécurité
```bash
make checkov
```

## Accès à l'instance
Le port 22 n'est PAS ouvert par défaut. La connexion se fait via **AWS Systems
Manager Session Manager** (rôle IAM déjà attaché par le module `iam`) :

```bash
aws ssm start-session --target <instance_id>
```

Si vous avez vraiment besoin de SSH, renseignez `allowed_ssh_cidr` dans
`terraform.tfvars` avec votre IP publique précise (jamais `0.0.0.0/0`).
