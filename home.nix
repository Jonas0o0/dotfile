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
  };

  xdg.configFile = {
    "hypr".source = ./dotfiles/hypr;
    "waybar".source = ./dotfiles/waybar;
    "alacritty".source = ./dotfiles/alacritty;
    "sheldon".source = ./dotfiles/sheldon;
    "fuzzel".source = ./dotfiles/fuzzel;
  };

  home.sessionVariables = {
    # EDITOR = "vim";
  };

  programs.home-manager.enable = true;
}
