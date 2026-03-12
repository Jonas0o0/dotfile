# Configuration NixOS (Flakes + Home Manager)

Bienvenue dans mon dépôt de configuration système NixOS. Cette configuration utilise **Flakes** et **Home Manager** pour gérer de manière déclarative le système d'exploitation, les paquets, et les fichiers de configuration de l'utilisateur (dotfiles).

L'environnement de bureau principal est **Hyprland** (Wayland).

---

## Architecture du dépôt

Le dépôt est organisé de manière modulaire :

- `flake.nix` & `flake.lock` : Les points d'entrée du système. Ils définissent les dépendances et la configuration de la machine.
- `hosts/bili/` : Les configurations spécifiques à la machine (matériel, bootloader, services).
  - `configuration.nix` : Configuration globale du système.
  - `hardware-configuration.nix` : Configuration matérielle générée automatiquement.
- `home.nix` : Configuration de Home Manager (liens symboliques pour les dotfiles, dossiers utilisateur).
- `packages.nix` : La liste complète et déclarative de tous les paquets installés sur le système par l'utilisateur.
- `dotfiles/` : Les fichiers de configuration des applications (Hyprland, Waybar, Alacritty, Zsh, etc.).
- `themes/` : Les ressources visuelles (fonds d'écran, thèmes GRUB).
- `scripts/` : Les scripts utilitaires, notamment le gestionnaire de paquets maison `os`.

---

## Gestion des paquets (Le script `os`)

Pour simplifier la gestion quotidienne, un script système interactif appelé `os` est disponible. Il permet d'installer, de supprimer et de mettre à jour le système sans avoir à éditer manuellement le fichier `packages.nix` (bien que ce soit toujours possible).

Vous pouvez exécuter `os --help` dans le terminal pour consulter la documentation intégrée.

### Commandes principales :

* **Rechercher un paquet** :
  ```bash
  os search <nom_du_paquet>
  ```
* **Installer des paquets** :
  ```bash
  os install discord spotify
  ```
  *Cette commande vérifie l'existence du paquet dans le registre, l'ajoute à `packages.nix`, recompile le système et propose la création d'un commit Git.*

* **Supprimer des paquets** :
  ```bash
  os remove discord
  ```

* **Mettre à jour le système** :
  ```bash
  os upgrade
  ```
  *Met à jour les dépendances Flake et lance une recompilation complète.*

* **Lister les paquets installés** :
  ```bash
  os list
  ```

* **Nettoyer le système** :
  ```bash
  os clean
  ```
  *Supprime les anciennes générations NixOS et optimise le stockage (utilisation de hardlinks pour libérer de l'espace disque).*

---

## Personnalisation et Thèmes

### Changer le fond d'écran
Le fond d'écran est centralisé afin de s'appliquer automatiquement à **Hyprland** (bureau) et **Hyprlock** (écran de verrouillage).

1. Remplacez l'image située dans `themes/wallpaper.jpg` par la nouvelle image (en conservant impérativement la nomenclature `wallpaper.jpg`).
2. Appliquez les modifications en reconstruisant le système :
   ```bash
   sudo nixos-rebuild switch --flake .#bili
   ```
   *(Cette opération mettra à jour le lien symbolique dans `~/Images/wallpaper.jpg` vers le nouveau fichier).*

### Changer l'image de profil (GDM / Écran de connexion)
L'image de l'écran de connexion est gérée automatiquement par la configuration système.
1. Placez la photo de profil sous le nom `portrait.jpg` dans le répertoire personnel `~/Images/`.
2. Lors du prochain redémarrage (ou `rebuild`), le système la détectera et l'appliquera à l'écran de connexion GDM.

---

## Gestion des Écrans (Hyprland)

La configuration Hyprland est conçue pour gérer le branchement d'écrans externes (hotplug) **nativement**, sans recours à des scripts de positionnement.

* **L'écran principal (`eDP-1`)** est défini comme le point de référence central (coordonnées `0x0`).
* **Les écrans externes** sont automatiquement positionnés **au-dessus** et **centrés horizontalement** par rapport à l'écran principal via la règle `auto-center-up` dans `hyprland.conf`.
* Cette disposition garantit l'absence de chevauchement, indépendamment de la résolution de l'écran externe (1080p, 4K, etc.).

Comportement lié au capot : La fermeture du capot alors qu'un écran externe est connecté entraîne la bascule des espaces de travail vers l'écran externe et la désactivation de l'écran interne pour préserver l'énergie (logique prise en charge par `dotfiles/hypr/handle-lid.sh`).

---

## Interaction avec l'IA (Gemini CLI)

Pour toute assistance sur cette configuration, l'IA doit **impérativement et exclusivement répondre en français**.