{ config, pkgs, ... }:

{
  home.username = "jonas";
  home.homeDirectory = "/home/jonas";

  home.stateVersion = "24.11"; 

  home.packages = import ./packages.nix { inherit pkgs; };

  # Gestion des fichiers de configuration (Dotfiles)
  home.file = {
    ".zshrc".source = ./dotfiles/zshrc;
    ".alias".source = ./dotfiles/alias;
    "Images/wallpaper.jpg" = {
      source = ./themes/wallpaper.jpg;
      force = true;
    };
  };

  xdg.configFile = {
    "hypr".source = ./dotfiles/hypr;
    "waybar".source = ./dotfiles/waybar;
    "alacritty".source = ./dotfiles/alacritty;
    "sheldon".source = ./dotfiles/sheldon;
    "fuzzel".source = ./dotfiles/fuzzel;
    "mako".source = ./dotfiles/mako;
  };

  home.sessionVariables = {
    # EDITOR = "vim";
  };

  services.batsignal = {
    enable = true;
    extraArgs = [
      "-w 20" # Warning at 20%
      "-c 10" # Critical at 10%
      "-d 5"  # Danger at 5% (will notify as critical)
    ];
  };

  programs.home-manager.enable = true;
}
