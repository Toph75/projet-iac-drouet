.ONESHELL:
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

INFO_COLOR := \033[36;1m
ERROR_COLOR := \033[31;1m
SUCCESS_COLOR := \033[32;1m
WARNING_COLOR := \033[33;1m
RESET_COLOR := \033[m

tf.init: ## --dry-run terraform init
	@echo "terraform init"

help: ## shows this help
	@echo -e "\n$(INFO_COLOR)=================MENU===========================$(RESET_COLOR)\n"
	@grep -hE "^[a-zA-Z_.-]+:.*?## .*$$" $(MAKEFILE_LIST) | sort
	@echo -e "\n$(INFO_COLOR)==================END OF MENU================$(RESET_COLOR)\n"
