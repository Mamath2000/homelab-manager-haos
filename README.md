# Homelab Manager — Home Assistant OS

Dépôt d'applications (add-ons) Home Assistant pour [Homelab Manager](https://github.com/Mamath2000/homelab-manager).

[![Ajouter le dépôt à Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FMamath2000%2Fhomelab-manager-haos)

| Application | |
|---|---|
| [Homelab Manager](homelab_manager/) | Le hub complet avec MongoDB, installé et sauvegardé dans Home Assistant OS |
| [Homelab Manager Agent](homelab_agent/) | L'agent du hub, dans Home Assistant OS : hôte, version, rattachement des sauvegardes Proxmox VE |

L'application **Homelab Manager** héberge le hub ; l'application **Homelab Manager Agent** rattache un Home Assistant à un hub.
Elles sont indépendantes : installe l'agent seulement si tu as déjà un hub ailleurs.

## Fonctionnement

- L'application Homelab Manager embarque le hub publié sur Docker Hub et MongoDB 7. Les données MongoDB sont conservées dans
  le volume persistant de l'application (`/data`).
- Son interface web est publiée sur le port `3000` et le serveur TLS des agents sur le port `3443`. Les agents se connectent
  au port TLS ; il doit être joignable depuis les hôtes administrés.
- Le workflow `sync-hub.yaml` suit les versions publiées du hub et publie l'application HAOS correspondante.
- L'option `timezone` règle le fuseau du hub (par défaut `Europe/Paris`).
- L'image (`ghcr.io/mamath2000/homelab-agent-haos`) part de `ghcr.io/home-assistant/base-debian` et reprend le **binaire
  signé** de l'agent dans l'image du hub (`mathmath350/homelab-manager:<HM_VERSION>`), sans le recompiler.
- La version de l'application agent est celle de l'agent. `sync.yaml` compare chaque jour l'agent de la dernière image du hub
  sur Docker Hub ; s'il a changé, l'image est construite et publiée, puis la version est écrite dans `config.yaml` :
  Home Assistant propose alors la mise à jour (ou l'installe, avec la mise à jour automatique).
- Un changement de l'empaquetage seul (`Dockerfile`, `rootfs/`) prend un suffixe de version (`0.1.23-1`), poussé à la main :
  `publish.yaml` construit l'image de cette version.
- Dans l'application, l'agent est en mode Home Assistant OS (`SUPERVISOR_TOKEN`) : OS et nom d'hôte lus par l'API
  Supervisor, aucune action annoncée, mise à jour interne désactivée (`AGENT_NO_SELFUPDATE=1`).

## Développement

`make help`. Build local : `make build` (image du hub publiée) ou `make build HUB_IMAGE=homelab-manager:latest` (image
locale du hub, `make docker-build` dans homelab-manager) ; `make lint` (ShellCheck, yamllint, par Docker).
