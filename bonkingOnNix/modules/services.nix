{
  config,
  pkgs,
  inputs,
  ...
}: {
  services = {
    blueman.enable = true;
    
    # XServer
    xserver = {
      enable = true;
      xautolock = {
        enable = true;
      };
      displayManager = {
        lightdm = {
          enable = true;
          greeters.pantheon.enable = true;
         #wayland = true;
        };
        sessionCommands = '' 
          xset -dpms
          xset s off
        '';

        sessionPackages = [
          #inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
        ];
      };

      desktopManager.gnome.enable = true;
      windowManager.xmonad.enable = true;
      windowManager.qtile = {
        enable = true;
      };
      
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
