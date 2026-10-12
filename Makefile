# Homelab Manager — application Home Assistant OS
APP        := homelab_agent
IMAGE      := homelab-agent-haos:local
VERSION    := $(shell sed -n 's/^version: "\(.*\)"/\1/p' $(APP)/config.yaml)
HM_VERSION := $(shell sed -n 's/^ARG HM_VERSION=//p' $(APP)/Dockerfile)
HUB_IMAGE  ?= mathmath350/homelab-manager:$(HM_VERSION)

.DEFAULT_GOAL := help
.PHONY: help version lint build shell sync

help: ## Affiche cette aide
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

version: ## Version de l'application et image du hub dont vient l'agent
	@echo "$(APP) $(VERSION) — agent de $(HUB_IMAGE)"

lint: ## ShellCheck des scripts s6, yamllint (par Docker)
	docker run --rm -v "$(CURDIR):/mnt:ro" koalaman/shellcheck:stable -x \
		/mnt/$(APP)/rootfs/etc/services.d/homelab-agent/run /mnt/$(APP)/rootfs/etc/services.d/homelab-agent/finish
	docker run --rm -v "$(CURDIR):/data:ro" cytopia/yamllint:latest -d '{extends: relaxed, rules: {line-length: {max: 140}}}' .

build: ## Image locale $(IMAGE) : make build [HUB_IMAGE=homelab-manager:latest]
	docker build --build-arg HUB_IMAGE=$(HUB_IMAGE) -t $(IMAGE) $(APP)

shell: ## Shell dans l'image locale
	docker run --rm -it --entrypoint bash $(IMAGE)

sync: ## Lance tout de suite la vérification de version (GitHub Actions)
	gh workflow run sync.yaml -R Mamath2000/homelab-manager-haos
