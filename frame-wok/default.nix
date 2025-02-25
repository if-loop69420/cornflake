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
  
  system.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.lix;
  # system.tools.nixos-option.enable = false;
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
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  networking.hostName = "frame-wok";
  services.fprintd = {
    enable = true;
  };
  
  systemd.targets.suspend.enable = true;
  
  environment.variables = {
    EDITOR = "hx";
    ROC_ENABLE_PRE_VEGA = "1";
  };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL="1";
  };

  environment.systemPackages = with pkgs; [
    typst
    gimp
    pandoc
    dig
    wget
    docker
    zsh
    qemu
    virt-manager
    git
    obs-studio
    inkscape
    podman
    dunst
    pavucontrol
    font-awesome
    dracula-theme 
    gnome-network-displays
    helix
    firefox
    firefox-wayland
    alacritty
    netcat-openbsd
    gcc
    glib
    lua
    luajit
    clang
    dbus
    waybar
    rofi-wayland
    mako 
    libnotify
    swayidle
    swaylock
    networkmanagerapplet
    pv
    polkit_gnome
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
    busybox
    keepassxc
    pfetch
    btop
    xclip
    wl-clipboard-rs
    gnupg
    flatpak
    libreoffice
    zettlr
    xwayland-satellite
    tor-browser
    texliveMedium
    screen
    minicom
    quickemu
    yazi
    prismlauncher
    jdk8
    corectrl
    fw-ectool
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

    niri = {
      enable = true;
      package = pkgs.niri-stable;
    };

    steam = {
      enable = false;
    };

    kdeconnect = {
      enable = false;
    };

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    wireshark = {
      enable = true;
    };

    virt-manager ={
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

    java = {
      enable = true;
    };
  };

  programs.light.enable = true;
  
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
    home = "/home/jeremy";
    description = "jeremy";
    extraGroups = [ "networkmanager" "dialout" "wheel" "docker" "libvirtd" "adbuser" "video" "input" "kvm"];
  };
  users.extraGroups.vboxusers.members = ["jeremy"];

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [zsh];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
    ];
  };
}
