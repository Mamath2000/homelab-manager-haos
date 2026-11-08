# Homelab Manager — Home Assistant OS

Dépôt d'applications (add-ons) Home Assistant pour [Homelab Manager](https://github.com/Mamath2000/homelab-manager).

[![Ajouter le dépôt à Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FMamath2000%2Fhomelab-manager-haos)

| Application | |
|---|---|
| [Homelab Manager Agent](homelab_agent/) | L'agent du hub, dans Home Assistant OS : hôte, version, rattachement des sauvegardes Proxmox VE |
| [Homelab Manager Agent (dev)](homelab_agent_dev/) | Version de développement de l'agent (releases dev, avant la prod) |

L'application **Homelab Manager Agent** rattache un Home Assistant à un hub, installé ailleurs (Docker : voir
[Installation](https://github.com/Mamath2000/homelab-manager/blob/main/docs/installation.md)). L'application **(dev)** suit les
versions de développement : à n'installer que pour tester, à la place de l'application prod (même fonctionnement, autre slug).

L'application du hub autonome (hub et MongoDB dans Home Assistant OS) a été retirée (homelab#317) : une installation existante
ne reçoit plus de mise à jour.

## Fonctionnement

- L'image (`ghcr.io/mamath2000/homelab-agent-haos`) part de `ghcr.io/home-assistant/base-debian` et reprend le **binaire
  signé** de l'agent dans l'image du hub (`mathmath350/homelab-manager:<HM_VERSION>`), sans le recompiler.
- La version de l'application agent est celle de l'agent. `sync.yaml` compare chaque jour l'agent de la dernière image du hub
  sur Docker Hub ; s'il a changé, l'image est construite et publiée, puis la version est écrite dans `config.yaml` :
  Home Assistant propose alors la mise à jour (ou l'installe, avec la mise à jour automatique).
- **Deux canaux.** Homelab Manager publie ses releases de développement sous `X.Y.Z-dev` (`make docker-release`) et ne
  publie `X.Y.Z` / `latest` qu'à la promotion (`make docker-promote`). `sync.yaml` suit les deux :
  les tags `X.Y.Z` pour `homelab_agent`, les tags `X.Y.Z-dev` pour `homelab_agent_dev` (image `…-haos-dev`).
  L'application dev n'a que son `config.yaml`, sa doc et ses traductions : son image est construite depuis le dossier de
  l'application prod. `make sync CHANNEL=dev` (ou `prod`)
  ne vérifie qu'un canal.
- Un changement de l'empaquetage seul (`Dockerfile`, `rootfs/`) prend un suffixe de version (`0.1.23-1`), poussé à la main :
  `publish.yaml` construit l'image de cette version.
- Dans l'application, l'agent est en mode Home Assistant OS (`SUPERVISOR_TOKEN`) : OS et nom d'hôte lus par l'API
  Supervisor, aucune action annoncée, mise à jour interne désactivée (`AGENT_NO_SELFUPDATE=1`).

## Développement

`make help`. Build local : `make build` (agent de l'image du hub publiée) ou `make build HUB_IMAGE=homelab-manager:latest` (image
locale du hub, `make docker-build` dans homelab-manager) ; `make lint` (ShellCheck, yamllint, par Docker).
