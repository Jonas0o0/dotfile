{ pkgs }:

with pkgs; [
  # Outils système et bureau
  waybar
  alacritty
  firefox
  swaybg
  gh
  python3
  nautilus
  fzf
  zoxide
  nodejs
  sheldon
  steam-run
  godot_4
  bruno
  wireguard-tools
  opam
  gcc
  m4
  gnumake
  jetbrains-toolbox
  aseprite
  chromium
  obsidian
  fuzzel
  postgresql
  discord

  # Outils Wayland / Hyprland (utilisés dans keybinds)
  brightnessctl
  playerctl
  wl-clipboard
  pavucontrol
  grim
  slurp
  jq
  acpi
  libnotify
 ]
