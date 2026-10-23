# Homelab Manager — application Home Assistant OS
APP        := homelab_agent
IMAGE      := homelab-agent-haos:local
VERSION    := $(shell sed -n 's/^version: "\(.*\)"/\1/p' $(APP)/config.yaml)
HM_VERSION := $(shell sed -n 's/^ARG HM_VERSION=//p' $(APP)/Dockerfile)
HUB_IMAGE  ?= mathmath350/homelab-manager:$(HM_VERSION)
HUB_APP    := homelab_manager
HUB_IMAGE_LOCAL := homelab-manager-haos:local
HUB_APP_VERSION := $(shell sed -n 's/^version: "\(.*\)"/\1/p' $(HUB_APP)/config.yaml)
HUB_VERSION := $(shell sed -n 's/^ARG HUB_VERSION=//p' $(HUB_APP)/Dockerfile)
MANAGER_IMAGE ?= mathmath350/homelab-manager:$(HUB_VERSION)

.DEFAULT_GOAL := help
.PHONY: help version lint build shell sync build-hub shell-hub sync-hub

help: ## Affiche cette aide
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

version: ## Version de l'application agent et image du hub dont vient l'agent
	@echo "$(APP) $(VERSION) — agent de $(HUB_IMAGE)"
	@echo "$(HUB_APP) $(HUB_APP_VERSION) — hub $(MANAGER_IMAGE)"

lint: ## ShellCheck des scripts s6, yamllint (par Docker)
	docker run --rm -v "$(CURDIR):/mnt:ro" koalaman/shellcheck:stable -x \
		/mnt/$(APP)/rootfs/etc/services.d/homelab-agent/run /mnt/$(APP)/rootfs/etc/services.d/homelab-agent/finish \
		/mnt/$(HUB_APP)/rootfs/etc/services.d/mongodb/run \
		/mnt/$(HUB_APP)/rootfs/etc/services.d/homelab-manager/run
	docker run --rm -v "$(CURDIR):/data:ro" cytopia/yamllint:latest -d '{extends: relaxed, rules: {line-length: {max: 140}}}' .

build: ## Image locale $(IMAGE) : make build [HUB_IMAGE=homelab-manager:latest]
	docker build --build-arg HUB_IMAGE=$(HUB_IMAGE) -t $(IMAGE) $(APP)

shell: ## Shell dans l'image locale
	docker run --rm -it --entrypoint bash $(IMAGE)

sync: ## Lance tout de suite la vérification de version (GitHub Actions)
	gh workflow run sync.yaml -R Mamath2000/homelab-manager-haos

build-hub: ## Image locale du hub autonome : make build-hub [MANAGER_IMAGE=…]
	docker build --build-arg HUB_IMAGE=$(MANAGER_IMAGE) -t $(HUB_IMAGE_LOCAL) $(HUB_APP)

shell-hub: ## Shell dans l'image locale du hub autonome
	docker run --rm -it --entrypoint bash $(HUB_IMAGE_LOCAL)

sync-hub: ## Lance tout de suite la vérification de version du hub (GitHub Actions)
	gh workflow run sync-hub.yaml -R Mamath2000/homelab-manager-haos
