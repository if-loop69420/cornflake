{
  config,
  pkgs,
  inputs,
  ...
}: let
in {
  imports = [
    ./hardware-configuration.nix
    ../modules
  ];

  nixpkgs.overlays = [inputs.niri.overlays.niri];
  
  system.stateVersion = "24.05";
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
      speedFactor = 4;
      supportedFeatures = [ "big-parallel" ];
      mandatoryFeatures = [ ];
      
    }
  ];
  nix.distributedBuilds = true;
  nix.extraOptions = '' 
    builders-use-substitutes = true
  '';
 
  
  # Random stuff 
  documentation = {
    enable  = true;
    dev.enable = true;
    man = {
      man-db.enable = true;
    };
  };
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
    ranger
    piper
    ptouch-driver
    man-pages
    man-pages-posix
    vulkan-validation-layers
    fuzzel
    jq
    waypaper
    swww
    cage
  ];
 
  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        zstd
      ];
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
    steam = {
      enable = false;
    };

    niri = {
      enable = true;
      package = pkgs.niri-stable;
    };

    kdeconnect = {
      enable = true;
    };

    starship = {
      enable = true;
      settings = {
        format = "$shlvl$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        shlvl = {
          disabled = false;
          symbol = ">";
          style = "bright-pink bold";
        };
        username = {
          style_user = "bright-white bold";
          style_root = "bright-red bold";
        };
      };
    };
  };

  programs.light.enable = true;
  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  #   # package = pkgs.swayfx;
  #   extraOptions = [
  #     "--verbose"
  #     "--debug"
  #     "--unsupported-gpu"
  #   ];
  # };
  
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
    extraGroups = [ "networkmanager" "dialout" "wheel" "docker" "libvirtd" "adbuser" "video" "input" "kvm"];
  };
  users.extraGroups.vboxusers.members = ["jeremy"];
  users.defaultUserShell = pkgs.nushell;
  environment.shells = with pkgs; [nushell];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
  };
}
