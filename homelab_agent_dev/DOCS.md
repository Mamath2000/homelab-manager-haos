# Homelab Manager Agent (dev)

Version de test : construite sur ce Home Assistant depuis la branche `main` du dépôt (quelques minutes), **Reconstruire**
pour reprendre le dernier commit. Mêmes réglages que [Homelab Manager Agent](https://github.com/Mamath2000/homelab-manager-haos/tree/main/homelab_agent),
mais données et certificat séparés : elle s'enrôle comme un hôte à part. Ne pas la laisser tourner à côté de la version
stable (même VM, même adresse MAC : le rattachement des sauvegardes Proxmox VE devient ambigu).
