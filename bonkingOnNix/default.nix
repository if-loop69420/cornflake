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
    open-vm-tools
    dmenu
    xmonad-with-packages
    xmobar
    vscode
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
    alacritty
    emacs
    netcat-openbsd
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
