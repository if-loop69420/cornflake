{
  config,
  pkgs,
  inputs,
  ...
}: {
  services = {
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;

    udev = {
      enable = true;
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
      layout = "at,us";
      libinput = {
        enable = true;
        touchpad.tapping = true;
      };
    };
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    
    flatpak.enable = true;
    dbus.enable = true;
    printing = {
      enable = true;
      drivers = with pkgs; [ hplip gutenprint ];
    };

    # emacs = {
    #   enable = true;
    #   package = pkgs.emacs;
    # };
    thermald = {
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
        CPU_MAX_PERF_ON_BAT = 20;

        CPU_BOOST_ON_AC=1;
        CPU_BOOST_ON_BAT=0;

        CPU_HWP_DYN_BOOST_ON_AC=1;
        CPU_HWP_DYN_BOOST_ON_BAT=0;
        
          
        USB_AUTOSUSPEND   =0;
        USB_EXCLUDE_BTUSB =1;

        
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
  };
}
