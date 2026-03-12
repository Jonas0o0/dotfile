#!/usr/bin/env bash

# monitor-layout.sh — Aligne dynamiquement les écrans.
# Place toujours l'écran externe au-dessus (à Y=0) et l'écran du laptop (eDP-1)
# en dessous, centré horizontalement, peu importe la résolution de l'externe.

LAPTOP="eDP-1"

# Récupérer les données des écrans
MONITORS=$(hyprctl monitors -j)

# Vérifier si l'écran externe existe
EXT_MONITOR=$(echo "$MONITORS" | jq -r "[.[] | select(.name != \"$LAPTOP\")][0]")

if [ "$EXT_MONITOR" != "null" ]; then
    EXT_NAME=$(echo "$EXT_MONITOR" | jq -r ".name")
    
    # Largeur et hauteur logique de l'externe (tenant compte d'une éventuelle mise à l'échelle)
    EXT_W=$(echo "$EXT_MONITOR" | jq -r "(.width / .scale) | round")
    EXT_H=$(echo "$EXT_MONITOR" | jq -r "(.height / .scale) | round")
    
    # Largeur logique du laptop
    LAPTOP_W=$(echo "$MONITORS" | jq -r ".[] | select(.name == \"$LAPTOP\") | (.width / .scale) | round")
    
    # Sécurité si le laptop n'est pas détecté correctement
    if [ -z "$LAPTOP_W" ] || [ "$LAPTOP_W" == "null" ]; then
        LAPTOP_W=1920
    fi

    # Calculer l'offset X pour centrer
    if [ "$EXT_W" -gt "$LAPTOP_W" ]; then
        OFFSET_X=$(( (EXT_W - LAPTOP_W) / 2 ))
        EXT_X=0
        LAPTOP_X=$OFFSET_X
    else
        OFFSET_X=$(( (LAPTOP_W - EXT_W) / 2 ))
        EXT_X=$OFFSET_X
        LAPTOP_X=0
    fi
    
    # Appliquer les positions : Externe en haut (Y=0), Laptop en bas (Y=EXT_H) et centré
    hyprctl keyword monitor "$EXT_NAME, preferred, ${EXT_X}x0, 1.0"
    hyprctl keyword monitor "$LAPTOP, preferred, ${LAPTOP_X}x${EXT_H}, 1.0"
else
    # Pas d'écran externe, le laptop est à 0x0
    hyprctl keyword monitor "$LAPTOP, preferred, 0x0, 1.0"
fi
