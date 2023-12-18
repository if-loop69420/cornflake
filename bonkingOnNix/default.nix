{
  config,
  pkgs,
  inputs,
  ...
}: let
in {
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];  
  
  system.stateVersion = "23.11";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["root" "@wheel"];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly"; 
    options = "--delete-old";
  };

  nix.buildMachines = [
    {
      hostName = "builder@172.18.2.21";
      systems = ["x86_64-linux" "aarch64-linux" "i686-linux"];

      maxJobs = 24;
      speedFactor = 2;
      supportedFeatures = [ "big-parallel" ];
      mandatoryFeatures = [ ];
      
    }
  ];
  nix.distributedBuilds = true;
  nix.extraOptions = '' 
    builders-use-substitutes = true
  '';
 
  
  # Random stuff 
  zramSwap.enable = true;
  sound.enable = true;
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  
  systemd.targets.suspend.enable = true;
  
  environment.variables.EDITOR = "hx";
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL="1";
  };

  environment.systemPackages = with pkgs; [
    wget
    docker
    zsh
    qemu
    virt-manager
    git
    open-vm-tools
    dmenu
    xmonad-with-packages
    xmobar
    obs-studio
    handbrake
    podman
    dunst
    pavucontrol
    font-awesome
    microcodeIntel
    dracula-theme 
    gnome-network-displays
    helix
    firefox
    firefox-wayland
    alacritty
    emacs
    netcat-openbsd
    gcc
    glib
    lua
    luajit
    clang
    dbus
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true"];
    })
    )
    rofi-wayland
    mako 
    libnotify
    swayidle
    swaylock
    hyprpaper
    networkmanagerapplet
    pv
    qtcreator
    espeak
    OVMFFull
    ccls
    zls
    polkit_gnome
    gnupg
    pulseaudio
  ];
 
  programs = {
    zsh = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
      };
    };
    nm-applet = {
      enable = true;
    };
    xwayland = {
      enable = true;
    };
    dconf = {
      enable = true;
    };
    steam = {
      enable = true;
    };
  };

  programs.light.enable = true;
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
  };
  
  # Security 
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };

  # Users
  users.users.jeremy = {
    isNormalUser = true;
    description = "jeremy";
    extraGroups = [ "networkmanager" "dialout" "wheel" "docker" "libvirtd" "adbuser" "video" "input"];
  };
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [zsh];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-wlr
    ];
  };
}
