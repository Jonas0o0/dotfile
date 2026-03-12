#!/usr/bin/env bash
# handle-lid.sh — Gère la fermeture/ouverture du capot du laptop
#
# Fermeture du capot :
#   - Si un écran externe est branché → migre tous les workspaces vers
#     l'écran externe, puis désactive eDP-1.
#   - Si aucun écran externe → met en veille (suspend).
#
# Ouverture du capot :
#   - Réactive l'écran du laptop.

LAPTOP_MONITOR="eDP-1"

# Compter le nombre de moniteurs actifs (hors le laptop)
count_external_monitors() {
    hyprctl monitors -j | jq "[.[] | select(.name != \"$LAPTOP_MONITOR\")] | length"
}

# Récupérer le nom du premier écran externe
get_external_monitor() {
    hyprctl monitors -j | jq -r "[.[] | select(.name != \"$LAPTOP_MONITOR\")][0].name"
}

if [ "$1" = "open" ]; then
    # Capot ouvert → réactiver l'écran du laptop
    hyprctl keyword monitor "$LAPTOP_MONITOR, preferred, 0x0, 1.0"

elif [ "$1" = "close" ]; then
    EXT_COUNT=$(count_external_monitors)

    if [ "$EXT_COUNT" -gt 0 ]; then
        EXT_MONITOR=$(get_external_monitor)

        # Récupérer tous les workspaces qui sont sur l'écran laptop
        WORKSPACES=$(hyprctl workspaces -j | jq -r ".[] | select(.monitor == \"$LAPTOP_MONITOR\") | .id")

        # Déplacer chaque workspace vers l'écran externe
        for ws in $WORKSPACES; do
            hyprctl dispatch moveworkspacetomonitor "$ws $EXT_MONITOR"
        done

        # Désactiver l'écran du laptop
        hyprctl keyword monitor "$LAPTOP_MONITOR, disable"
    else
        # Aucun écran externe → mettre en veille
        systemctl suspend
    fi
fi

