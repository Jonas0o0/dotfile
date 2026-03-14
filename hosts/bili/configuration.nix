{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader (GRUB)
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.theme = ../../themes/crossgrub;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.configurationLimit = 3;

  networking.hostName = "bili"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  networking.wireguard.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    keyMap = "fr";
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  nixpkgs.config.allowUnfree = true;
  services.xserver.enable = true;
  services.xserver.xkb.layout = "fr";
  services.xserver.desktopManager.xterm.enable = false;

  # Enable GDM (GNOME Display Manager)
  services.displayManager.gdm.enable = true;

  # Laisser Hyprland gérer la fermeture du capot (migration des workspaces)
  # Le script handle-lid.sh suspend manuellement si aucun écran externe n'est branché
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
    LidSwitchIgnoreInhibited = "yes";
  };

  programs.hyprland.enable = true;

  environment.variables = {
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  programs.zsh.enable = true;

  # Enable Hyprlock
  programs.hyprlock.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  xdg.portal.config.common.default = [ "hyprland" ];
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];

  hardware.graphics.enable = true;
  virtualisation.docker.enable = true;


  # Enable Fingerprint support
  services.fprintd.enable = true;

  security.pam.services = {
    login.fprintAuth = lib.mkForce true;
    sudo.fprintAuth = true;
    # On autorise spécifiquement fprintAuth pour hyprlock et on le met en priorité
    hyprlock = {
      fprintAuth = true;
    };
  };

  # Define a user account.
  users.users.jonas = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    # Packages are now managed by Home Manager in home.nix
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    htop
    fastfetch
    adwaita-icon-theme
    gemini-cli
    git # Ensure git is available for flakes
    hypridle
    docker-compose
  ];

  programs.nix-ld.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # --- OPTIMISATION AMD & BATTERIE ---
  boot.kernelParams = [ "amd_pstate=active" "quiet" "splash" "loglevel=3" "vt.global_cursor_default=0" "rd.udev.log_priority=3" "systemd.show_status=false" ];

  services.tlp = {
    enable = true;
    settings = {
      # Driver AMD
      AMD_PSTATE_STATUS = "active";
    
      # Sur Batterie : On privilégie l'autonomie maximale
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power"; # C'est ici que le gain est énorme
      CPU_MAX_PERF_ON_BAT = 60; # Limiter à 60% de la puissance évite la chauffe
    
      # Sur Secteur : On libère la puissance du R7
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    
      # Optimisation Wi-Fi et Audio
      WIFI_PWR_ON_BAT = "on";
      SOUND_POWER_SAVE_ON_BAT = 1;
    };
  };
  services.power-profiles-daemon.enable = false; # Toujours désactivé si TLP est là
  # services.thermald.enable = false; # Supprimé car inutile sur AMD

  # --- KERNEL TWEAKS & ZRAM ---
  # ZRAM
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  boot.kernel.sysctl = {
    # On réduit légèrement le swappiness (60 au lieu de 100) pour éviter la surcharge CPU au boot
    "vm.swappiness" = 60; 
    # Optimisation spécifique à la ZRAM
    "vm.page-cluster" = 0; 
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_writeback_centisecs" = 1500;
  };

  # --- AJOUTS SYSTÈME CONSEILLÉS ---
  # Utiliser le kernel le plus récent pour un meilleur support AMD P-State
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Maintenir les performances et la santé du SSD
  services.fstrim.enable = true;

  # Mettre à jour le microcode du CPU AMD
  hardware.cpu.amd.updateMicrocode = true;

  # Set GDM profile picture (Sécurisé)
  system.activationScripts.gdmProfilePicture.text = ''
    if [ -f /home/jonas/Images/portrait.jpg ]; then
      mkdir -p /var/lib/AccountsService/icons
      cp -f /home/jonas/Images/portrait.jpg /var/lib/AccountsService/icons/jonas
      mkdir -p /var/lib/AccountsService/users
      echo -e "[User]\nIcon=/var/lib/AccountsService/icons/jonas\n" > /var/lib/AccountsService/users/jonas
    fi
  '';

  system.stateVersion = "25.11";
}
