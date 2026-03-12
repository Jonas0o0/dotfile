#!/usr/bin/env bash

# monitor-hotplug.sh — Écoute les événements Hyprland en continu (socket IPC)
# et réaligne automatiquement les écrans au moindre branchement.

# Attendre que la session Hyprland soit bien démarrée
sleep 2

# On utilise "nix run nixpkgs#socat" pour éviter de devoir l'installer en dur
nix run nixpkgs#socat -- -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    case "$line" in
        monitoradded*)
            # Un écran vient d'être branché
            ~/.config/hypr/monitor-layout.sh
            ;;
        monitorremoved*)
            # Un écran vient d'être débranché
            ~/.config/hypr/monitor-layout.sh
            ;;
    esac
done
