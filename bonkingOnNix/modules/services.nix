{
  config,
  pkgs,
  ...
}: {
  services = {
    blueman.enable = true;
    
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
      layout = "at";
      libinput = {
        enable = true;
        touchpad.tapping = true;
      };
    };
    printing.enable = true;
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    
    flatpak.enable = true;
    dbus.enable = true;
   
    
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      ensureUsers = [
        {
          name = "jeremy";
          ensurePermissions = {
            "*.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };
  };
}