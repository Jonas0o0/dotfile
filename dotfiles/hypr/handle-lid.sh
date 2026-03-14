#!/usr/bin/env bash

# Script de gestion du capot (Lid Switch) pour Hyprland
# géré par NixOS config

case "$1" in
    close)
        # Si un écran externe est branché, on désactive juste l'écran interne
        if hyprctl monitors | grep -q "Monitor" && [ $(hyprctl monitors | grep -c "Monitor") -gt 1 ]; then
            hyprctl keyword monitor "eDP-1, disable"
        else
            # Sinon on suspend le laptop
            systemctl suspend
        fi
        ;;
    open)
        # On réactive l'écran interne
        hyprctl keyword monitor "eDP-1, highres, 0x0, 1"
        ;;
esac
