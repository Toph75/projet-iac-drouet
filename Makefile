# Makefile racine — inclut tous les fragments du dossier make/
# Gardez vos fichiers existants (ansible.mk, common.mk, git.mk, github.mk) tels quels :
# ce fichier se contente de les assembler avec le nouveau terraform.mk.

include make/common.mk
include make/git.mk
include make/github.mk
include make/ansible.mk
include make/terraform.mk

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "Cibles disponibles : tf-init, tf-plan, tf-apply, checkov (voir make/terraform.mk)"
