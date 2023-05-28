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
 
  
  # Random stuff 
  zramSwap.enable = true;
  sound.enable = true;
  
  systemd.targets.suspend.enable = true;
  
  environment.variables.EDITOR = "hx";
  environment.systemPackages = with pkgs; [
    wget
    docker
    zsh
    qemu
    libvirt
    virt-manager
    git
    glib
    gtk3
    gtk4
    gcc
    elixir
    erlang
    lz4
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
    vscode
    obs-studio
    handbrake
    podman
    dunst
    pavucontrol
    php
    font-awesome
    microcodeIntel
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
    alacritty
    emacs
    netcat-openbsd
    haskellPackages.fourmolu
    haskellPackages.containers_0_6_7
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
  environment.shells = with pkgs; [zsh];
}
