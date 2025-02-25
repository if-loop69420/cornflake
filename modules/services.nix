{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  services = {
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;

    fwupd.enable = true;
    power-profiles-daemon.enable = true;

    udev = {
      enable = true;
      packages = with pkgs; [
        android-udev-rules
        via
        vial
      ];
    };

    tailscale = {
      enable = true;
    };

    logind = {
      powerKey = "hibernate";
      powerKeyLongPress = "poweroff";
      lidSwitch = "hibernate";
      lidSwitchDocked = "hibernate";
      lidSwitchExternalPower = "hibernate";
    };

    davfs2.enable = true;
          
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
     
      # General stuff
      videoDrivers = ["amdgpu"];
      xkb.layout = "at,us";
    };

    # dnsmasq = {
      # enable = true;
      # settings = {
        # server = [
        #   "192.168.1.1"
        # ];

        # address="/robo4you.at/172.16.0.1";
        # bind-interfaces = true;
        # interface = ["lo"];
      # };
    # };

    # resolved = {
    #   enable = true;
    #   # domains = [ "~."];
    #   dnssec = "true";
    #   fallbackDns = ["100.100.100.100" "1.1.1.1#one.one.one.one" "172.16.0.1"];
    #   dnsovertls = "true";
    # };
    
    libinput = {
      enable = true;
      touchpad.tapping = true;
    };
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    
    flatpak.enable = true;
    dbus = {
      enable = true;
      packages = with pkgs; [ pkgs.gcr ];
    };
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
      enable = false;
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
        
          
        USB_AUTOSUSPEND   =1;

        START_CHARGE_THRESH_BAT0 = 0;
        STOP_CHARGE_THRESH_BAT0 = 0;
        RESTORE_THRESHOLDS_ON_BAT=0;

        NATACPI_ENABLE=1;
      };
    };
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
