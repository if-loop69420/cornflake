{
  config,
  pkgs,
  inputs,
  ...
}: {
  services = {
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    
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
      enable = false;
      drivers = with pkgs; [ hplip gutenprint ];
    };
  };
}
