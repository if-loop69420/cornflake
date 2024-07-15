{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports =  [
  "${inputs.wazuhPkgs}/nixos/modules/services/security/wazuh/wazuh.nix"
  ];
  services = {
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;

    udev = {
      enable = true;
      packages = with pkgs; [
        android-udev-rules
        via
        vial
      ];
    };

    wazuh = {
      agent = {
        enable = true;
        # ip 10.0.0.152
        managerIP = "10.0.0.152";
        # default port        
        # agent-name Jeremy-Sztavinovszki
        # group Linux
      };
    };
          
    # XServer
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };

        sessionCommands = '' 
          xset -dpms
          xset s off
        '';
      };
      desktopManager.gnome.enable = true;
      windowManager.xmonad.enable = true;
     
      # General stuff
      videoDrivers = ["nvidia"];
      xkb.layout = "at,us";
    };

    
    libinput = {
      enable = true;
      touchpad.tapping = true;
    };
    
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    
    flatpak.enable = true;
    dbus.enable = true;
    printing = {
      enable = true;
      drivers = with pkgs; [ hplip gutenprint samsung-unified-linux-driver ptouch-driver];
    };

    thermald = {
      enable = true;
    };

    ratbagd = {
      enable = true;
    };
    
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 66;

        CPU_BOOST_ON_AC=1;
        CPU_BOOST_ON_BAT=0;

        CPU_HWP_DYN_BOOST_ON_AC=1;
        CPU_HWP_DYN_BOOST_ON_BAT=0;
        
          
        USB_AUTOSUSPEND   =0;
        USB_EXCLUDE_BTUSB =0;

        START_CHARGE_THRESH_BAT0 = 0;
        STOP_CHARGE_THRESH_BAT0 = 0;
        RESTORE_THRESHOLDS_ON_BAT=0;

        NATACPI_ENABLE=1;
      };
    };
    power-profiles-daemon.enable = false;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
    services.NetworkManager-wait-online.enable = lib.mkForce false;

  };


  
}
