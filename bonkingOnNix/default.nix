{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];  
  
  system.stateVersion = "23.05";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];
  
  
  # Random stuff 
  zramSwap.enable = true;
  sound.enable = true;
  
  systemd.targets.suspend.enable = true;
  
  environment.variables.EDITOR = "hx";
  environment.systemPackages = with pkgs; [
    wget
    pkgs.docker
    pkgs.zsh
    pkgs.qemu
    pkgs.libvirt
    virt-manager
    git
    glib
    gtk3
    gtk4
    gcc
    elixir
    erlang
    lz4
    steam
    pkg-config
    ghc
    stack
    open-vm-tools
    openjdk11
    dmenu
    xmonad-with-packages
    xmobar
    cargo
    rustup
    pkgs.vscode
    obs-studio
    handbrake
    podman
    dunst
    pavucontrol
    php
    font-awesome
    microcodeIntel
    qt5.full
    dracula-theme 
    clang
    rust-bindgen
    kotlin
    eigen
    glib
    gnome-network-displays
    wayland
    wlr-randr
    wl-clipboard
    wlogout
    libnotify
    helix
    firefox
  ];
 
  programs = {
    steam = {
      enable = true;
    };
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
  };
  
  # Security 
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };
  
  # Users
  users.users.jeremy = {
    isNormalUser = true;
    description = "jeremy";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "adbuser" ];
  };
  users.defaultUserShell = pkgs.zsh;
}
