{ config, pkgs, ... }:

let 
  customNvim = import ./nvim/nvim.nix;
  customZsh = import ./zsh.nix;
  customHelix = import ./helix.nix;
  customNiri = import ./niri.nix;
  customEmacs = import ./emacs/emacs.nix;
in 
{
  home.stateVersion="24.11";
  home.username="jeremy";
  home.homeDirectory="/home/jeremy";
  programs.neovim = customNvim pkgs;
  programs.zsh = customZsh pkgs;
  programs.helix = customHelix pkgs;
  programs.niri = customNiri config pkgs;
  programs.emacs = customEmacs config pkgs;
  home.packages = with pkgs;[
    anki-bin
    catppuccin-gtk
    lazygit
    vimPlugins.nvim-treesitter
    swaylock-effects
    swayidle
    wofi
    librsvg
    clipman
    wl-clipboard
    foliate
    espeak
    distrobox
    xq
    signal-desktop
    remmina
    firefox-wayland
    anki-bin
    grimblast
    nixd
    vial
    zotero
    ncdu
    fzf
    gnome-solanum
    geogebra6
  ];

  programs.zoxide = {
    enable = true;
    # enableNushellIntegration = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
    };
  };

  programs.carapace = {
    enable = true;
    # enableNushellIntegration = true;
  };

  programs.starship = {
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
  

  programs.git = {
    enable = true;
    userName = "if-loop69420";
    userEmail = "j.sztavi@pm.me";
  };

  programs.nushell = {
    enable = true;
    extraConfig = '' 
      let carapace_completer = {|spans|
      carapace $spans.0 nushell ...$spans | from json
      }
    
      $env.config = {
        show_banner: false
        completions: {
        case_sensitive: false # case-sensitive completions
        quick: true    # set to false to prevent auto-selecting completions
        partial: true    # set to false to prevent partial filling of the prompt
        algorithm: "fuzzy"    # prefix or fuzzy
        external: {
        # set to false to prevent nushell looking into $env.PATH to find more suggestions
            enable: true 
        # set to lower can improve completion performance at the cost of omitting some options
            max_results: 100 
            completer: $carapace_completer # check 'carapace_completer' 
          }
        }
      }

      alias sys-rebuild = sudo nixos-rebuild switch --flake '/home/jeremy/.config/dotfiles/#'
      alias anki-bin = ANKI_WAYLAND=1 anki-bin
      source ~/.zoxide.nu
      source ~/.cache/starship/init.nu
      $env.CARAPACE_BRIDGES = 'zsh,bash'
      if ($env | get -i TMUX | is-empty) {
        tmux
      }
    '';

    
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      vadimcn.vscode-lldb
    ];
  };

  services.mako = {
    enable = true;
    actions = true;
    backgroundColor = "#282A36";
    borderColor = "#44475A";
    borderRadius = 10;
    defaultTimeout = 5000;
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod1";
      # Use kitty as default terminal
      terminal = "alacritty"; 
      startup = [
        # Launch Firefox on start
        {command = "sh -c ~/.config/start.sh";}
        {command = "light -I";}
      ];
    };
  };


  programs.tmux = {
    enable = true;
    clock24 = true;
    shortcut = "x";
    secureSocket=true;
    plugins = with pkgs; [
      tmuxPlugins.catppuccin
      tmuxPlugins.vim-tmux-navigator
    
    ];
    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"
      set -g mouse on

      # Start windows and panes at 1, not 0
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Shift arrow to switch windows
      bind -n S-Left  previous-window
      bind -n S-Right next-window

      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      # set vi-mode
      set-window-option -g mode-keys vi
      # keybindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };

  programs.waybar = {
    enable = true; 
    settings = {
      mainBar = {
        layer="top";
        position="top";
        height = 30;
        output = [
          "eDP-1"
          "DP-1"
        ];
        modules-left = ["niri/workspaces" "niri/window" "niri/language" "mpd"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio/slider" "pulseaudio" "temperature" "cpu" "memory" "network" "power-profiles-daemon" "upower" "tray" "custom/power"];

        "network" = {
          interface= "wlp1s0";
          format= "{ifname}";
          format-wifi= "{essid} ({signalStrength}%)  ";
          format-ethernet= "{ipaddr}/{cidr} 󰊗 ";
          format-disconnected= "";
          tooltip-format= "{ifname} via {gwaddr} 󰊗";
          tooltip-format-wifi= "{essid} ({signalStrength}%)  ";
          tooltip-format-ethernet="{ifname} ";
          tooltip-format-disconnected="Disconnected ";
          max-length= 50;
        };

        "power-profiles-daemon"= {
          format= "{icon} ";
          tooltip-format= "Power profile: {profile}\nDriver: {driver}";
          tooltip= true;
          format-icons= {
            default= "";
            performance= "";
            balanced= "";
            power-saver= "";
          };
        };

        "cpu"= {
           interval= 1;
           format= "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}{icon8}{icon9}{icon10}{icon11}{icon12}{icon13}{icon14}{icon15}";
           format-icons = [
             "<span color='#69ff94'>▁</span>" 
             "<span color='#2aa9ff'>▂</span>" 
             "<span color='#f8f8f2'>▃</span>" 
             "<span color='#f8f8f2'>▄</span>" 
             "<span color='#ffffa5'>▅</span>" 
             "<span color='#ffffa5'>▆</span>" 
             "<span color='#ff9977'>▇</span>" 
             "<span color='#dd532e'>█</span>" 
         ];
        };
        "memory"= {
            interval= 30;
            format= "{}% ";
            max-length= 10;
        };

        "pulseaudio/slider" = {
          min = 0;
          max = 100;
          orientation="horizontal";
        };

        "pulseaudio"= {
          format= "{volume}% {icon} ";
          format-bluetooth= "{volume}% {icon}";
          format-source = "{volume}% 🎙 ";
          format-source-muted = " ";  
          format-muted= " ";
          on-click = "pavucontrol";
          default = [" " " " " "];
          hands-free = "🎙 ";
          hands-free-muted = " ";  
        };

        "temperature" = {
          format = "{temperatureC}°C";
        };

        "custom/power" = {
          format = "⏻ ";
          tooltip = false;
          menu = "on-click";
          menu-file = "$HOME/.config/waybar/power_menu.xml";
          menu-actions = {
            shutdown = "shutdown";
            reboot = "reboot";
            suspend = "systemctl suspend";
            hibernate = "systemctl hibernate";
          };
        };
      };
    };
    
    style = '' 
    @define-color background-darker rgba(30, 31, 41, 230);
    @define-color background #282a36;
    @define-color selection #44475a;
    @define-color foreground #f8f8f2;
    @define-color comment #6272a4;
    @define-color cyan #8be9fd;
    @define-color green #50fa7b;
    @define-color orange #ffb86c;
    @define-color pink #ff79c6;
    @define-color purple #bd93f9;
    @define-color red #ff5555;
    @define-color yellow #f1fa8c;
    * {
        border: none;
        border-radius: 5px;
        font-family: Iosevka;
        font-size: 10pt;
        min-height: 0;
        min-width: 10px;
    }

    window#waybar {
      color: @foreground;
      background: linear-gradient(0deg, rgba(40, 42, 54, 0.12) 0%, rgba(40,42,54,0.6) 100%);
    }

    #workspaces button {
      color: @foreground;
      background: rgba(40, 42, 54, 0.5);
    }

    #workspaces button.active {
      background: rgba(30, 31, 41, 0.6); 
    }
    
    #pulseaudio-slider slider {
      min-height: 0px;
      min-width: 0px;
      opacity: 0;
      background-image: none;
      border: none;
      border-radius: 10px;
      box-shadow: none;
      background: @pink;
    }
    #pulseaudio-slider trough {
      min-height: 10px;
      min-width: 80px;
      border-radius: 5px;
      background-color: rgba(0,0,0,0.4);
    }
    #pulseaudio-slider highlight {
      border-radius: 5px;
      background-color: @green;
    }
    #pulseaudio, #cpu, #memory, #power-profiles-daemon, #upower, #network {
      margin-left: 2px;
      margin-right: 2px;
      padding-left: 8px;
      padding-right: 8px;
      background: rgba(30, 31, 41, 0.6); 
    }
    #clock {
     background: rgba(30, 31, 41, 0.6); 
    }
    #cpu {
      background: rgba(40, 42, 54, 0.5);
      color: @foreground;
    }
    #network {
      min-width: 20px;
    }
    #power-profiles-daemon {
      min-width: 20px;
    }
    #memory {
      background: @purple;
    }
    #pulseaudio {
      background: @orange;
    }
    #temperature {
      background: @red;
    }
    #network {
      background: @green;
    }
    #power-profiles-daemon.performance { 
      background: @red;
    }
    #power-profiles-daemon.balanced { 
      background: #5d8cf0;
    }
    #power-profiles-daemon.power-saver { 
      background: @green;
    }
    '';
  };
}
