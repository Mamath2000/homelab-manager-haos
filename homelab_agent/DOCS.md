# Homelab Manager Agent

Agent [Homelab Manager](https://github.com/Mamath2000/homelab-manager) pour Home Assistant OS. Il fait apparaître ce
Home Assistant comme un hôte du hub :

- OS (version de Home Assistant OS), adresses IP, virtualisation ;
- **sauvegarde Proxmox VE** : l'application voit le réseau de la VM, dont l'adresse MAC relie l'hôte à sa VM ; les sauvegardes
  vzdump de la VM sur le Proxmox Backup Server s'y rattachent toutes seules.

L'agent ne fait aucune action sur Home Assistant : système, Core et applications se mettent à jour dans Home Assistant.

## Installation

1. Dans Homelab Manager, **Ajouter un hôte**, puis l'onglet **Home Assistant OS** : copie le jeton d'installation.
2. Ici, onglet **Configuration** : colle le jeton dans `install_token`, enregistre.
3. Démarre l'application. L'hôte passe « En ligne » dans le hub quelques secondes plus tard (sinon : onglet **Journal**).
4. Active **Mise à jour automatique** : l'agent suit les versions de Homelab Manager.

Le jeton contient l'adresse du hub, sa clé épinglée et un code à usage unique (24 h). Il ne sert qu'au premier démarrage :
l'agent reçoit un certificat, gardé dans l'application. Un nouveau jeton (après une révocation, un changement de hub…)
réenrôle l'agent au démarrage suivant.

## Mises à jour

L'agent ne se met pas à jour lui-même : chaque nouvelle version de l'agent dans Homelab Manager donne une nouvelle version
de l'application (vérifiée chaque jour), installée par Home Assistant, automatiquement si **Mise à jour automatique** est
activé. En attendant, le hub affiche l'agent « à mettre à jour ».

## Désinstallation

Supprime l'hôte dans Homelab Manager (ou révoque son agent), puis désinstalle l'application.
