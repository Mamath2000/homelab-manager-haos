# Homelab Manager

Cette application installe le hub Homelab Manager et sa base MongoDB dans Home Assistant OS. Les données de la base sont
conservées dans le stockage persistant de l'application, y compris lors de ses mises à jour.

## Installation

1. Installe et démarre l'application.
2. Ouvre **Interface web** ou va sur `http://<adresse-de-Home-Assistant>:3000`.
3. Au premier démarrage, récupère dans le journal de l'application le mot de passe à usage unique de `superadmin`, puis
   connecte-toi et crée les comptes habituels.
4. Dans le hub, vérifie **Paramètres > Agent** : l'adresse du hub et le port TLS doivent être joignables depuis les hôtes
   administrés. Le port par défaut est `3443`.
5. Sur chaque hôte, lance la commande d'installation générée depuis le hub. Pour un autre Home Assistant OS, utilise
   l'application **Homelab Manager Agent** du dépôt.

## Ports

| Port | Usage |
| --- | --- |
| `3000/tcp` | Interface web et API du hub |
| `3443/tcp` | Connexions TLS des agents (installation, enrôlement et WebSocket) |

Les agents doivent pouvoir joindre le port `3443` à l'adresse du Home Assistant qui héberge ce hub. Si un port est déjà
utilisé, modifie son port hôte dans la configuration réseau de l'application puis reporte le port TLS choisi dans
**Paramètres > Agent**.

L'interface du hub utilise HTTP sur le port `3000` : garde-la sur le réseau local, et ne publie pas ces ports sur Internet.
Pour un accès distant, place le hub derrière un reverse proxy HTTPS et une authentification supplémentaire.

## Options

| Option | Description |
| --- | --- |
| `timezone` | Fuseau horaire du hub, au format IANA, par exemple `Europe/Paris`. |

## Sauvegardes et limites

- La base MongoDB se trouve dans le répertoire persistant `/data/mongodb`. Une sauvegarde HAOS de l'application inclut
  donc les données du hub.
- Désinstaller l'application supprime son stockage : exporte ou sauvegarde les données avant toute désinstallation.
- MongoDB 7 requiert une architecture CPU compatible. Les appareils `amd64` doivent prendre en charge AVX ; les appareils
  `aarch64` doivent respecter les prérequis ARM64 de MongoDB 7. Les machines trop anciennes peuvent ne pas démarrer la base.
- Le hub n'installe pas d'agent sur le Home Assistant qui l'héberge. Pour le gérer comme hôte, installe également
  **Homelab Manager Agent** et configure-le avec le jeton généré par le hub.

Le projet est distribué sous licence MIT. Aide et signalement de problèmes : <https://github.com/Mamath2000/homelab-manager-haos/issues>.
