# Configuration NixOS (Flakes + Home Manager) - Hôte : "bili"

Ce dépôt contient la configuration système complète, déclarative et reproductible de la machine "bili". L'architecture repose sur l'utilisation de Nix Flakes pour la gestion des sources et de Home Manager pour l'environnement utilisateur.

L'interface utilisateur s'appuie sur le gestionnaire de fenêtres composite Wayland Hyprland.

---

## Spécifications Techniques

### Optimisation Matérielle (AMD)
La configuration est optimisée pour les processeurs AMD récents :
- Gestion active des états de performance via le pilote `amd_pstate=active`.
- Régulation énergétique via TLP avec profils distincts pour l'alimentation sur secteur et sur batterie.
- Mise à jour automatique du microcode CPU.

### Interface et Environnement de Bureau
- Gestionnaire de fenêtres : Hyprland (Wayland).
- Barre d'état : Waybar.
- Terminal : Alacritty.
- Lanceur d'applications : Fuzzel.
- Shell : Zsh géré par Sheldon, intégrant fzf et zoxide pour la navigation.

### Sécurité et Authentification
L'authentification système utilise le sous-système PAM (Pluggable Authentication Modules) avec les composants suivants :
- fprintd : Gestion du lecteur d'empreintes digitales.
- Hyprlock : Écran de verrouillage supportant l'authentification par empreinte et mot de passe en parallèle.
- Sudo : Validation des privilèges administratifs par biométrie.

---

## Architecture du Dépôt

L'arborescence est organisée de manière modulaire pour faciliter la maintenance :

- flake.nix : Point d'entrée définissant les entrées nixpkgs et les configurations système.
- flake.lock : Verrouillage des révisions exactes des dépendances.
- configuration.nix : Paramètres globaux du système d'exploitation.
- home.nix : Configuration de l'environnement utilisateur et des liens symboliques.
- packages.nix : Définition de la liste des paquets installés.
- dotfiles/ : Répertoire des fichiers de configuration spécifiques aux applications.
- hosts/bili/ : Paramètres spécifiques au matériel (firmwares, bootloader).
- themes/ : Ressources graphiques (fonds d'écran, thèmes système).
- scripts/ : Utilitaires système internes.

---

## Déploiement et Maintenance

### Application de la configuration
Pour déployer les modifications ou reconstruire le système :
```bash
sudo nixos-rebuild switch --flake .#bili
```

### Gestion des Paquets (Utilitaire 'os')
Un script d'interface ('os') permet d'interagir avec la configuration de manière sécurisée.

| Commande | Action |
| :--- | :--- |
| os search [query] | Recherche un paquet dans le registre nixpkgs. |
| os install [pkg] | Ajoute le paquet à packages.nix et reconstruit le système. |
| os remove [pkg] | Retire le paquet de la configuration et reconstruit le système. |
| os upgrade | Met à jour les entrées du flake et effectue une montée de version système. |
| os list | Affiche la liste des paquets explicitement installés. |
| os clean | Collecte les déchets (garbage collection) et optimise le stockage Nix. |

---

## Configuration de l'Affichage et des Périphériques

### Gestion Multi-écran
La configuration Hyprland gère dynamiquement les écrans externes (hotplug) :
- L'écran interne (eDP-1) sert de référence.
- Les écrans externes sont automatiquement centrés au-dessus de l'écran principal.
- Le script 'handle-lid.sh' gère le comportement lors de la fermeture du capot pour assurer la continuité des espaces de travail.

### Personnalisation Graphique
Le fond d'écran système est centralisé via le fichier `themes/wallpaper.jpg`. Sa modification nécessite une reconstruction du système pour mettre à jour les liens symboliques vers `~/Images/wallpaper.jpg`.

Le chargeur de démarrage GRUB utilise le thème CrossGrub et est configuré pour ne conserver que les trois dernières générations du système afin d'optimiser le menu de démarrage.

---

## Conformité et Assistance

Les instructions relatives à l'assistance par intelligence artificielle sont consignées dans GEMINI.md. Toute communication technique concernant ce dépôt doit être effectuée exclusivement en langue française.
