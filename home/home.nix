{ config, pkgs, ... }:

let 
  customNvim = import ./nvim/nvim.nix;
  customZsh = import ./zsh.nix;
  customHelix = import ./helix.nix;
in 
{
  home.stateVersion="24.05";
  home.username="jeremy";
  home.homeDirectory="/home/jeremy";
  programs.neovim = customNvim pkgs;
  programs.zsh = customZsh pkgs;
  programs.helix = customHelix pkgs;
  home.packages = with pkgs;[
    catppuccin-gtk
    lazygit
    vimPlugins.nvim-treesitter
    swaylock-effects
    swayidle
    wofi
    clipman
    wl-clipboard
    steam
    foliate
    espeak
    distrobox
    xq
    signal-desktop
    remmina
    firefox-wayland
    anki-bin
    grimblast
  ];

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
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
      matklad.rust-analyzer
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
        {command = "~/.config/start.sh";}
      ];
    };
  };


  programs.niri = {
    settings = {
      input = {
        keyboard.xkb = {
          layout = "de,us";
          options = "grp:win_space_toggle";
        };
        touchpad = {
          dwt = true;
          tap = true;
          natural-scroll = false;
        };
        mouse = {
          natural-scroll = false;
        };
      };

      outputs."eDP-1" = {
        mode = {
          height = 1080;
          width = 1920;
          refresh = 60.056;
        };
        variable-refresh-rate = true;
      };

      layout = {
        gaps = 16;
        center-focused-column = "never";
        # default-column-width = 1.;
        # preset-column-widths = [
          # { proportion = 1./3.; }
          # { proportion = 1./2.; }
          # { proportion = 2./3.; }
        # ];

        
        focus-ring = {
          enable = true;
          # active = "#7fc8ff";
          # inactive = "#505050";
          width = 4;
        };

        border = {
          enable = true;
          width = 4;
          # active = "#ffc87f";
          # inactive = "#505050";
        };
      };

      spawn-at-startup = [
        { command = ["bash" "-c" "~/.config/start.sh"]; }
      ];

      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%s.png";
      
      binds = with config.lib.niri.actions; {
        # Generally important binds
        "Alt+Shift+Slash".action = show-hotkey-overlay;
        "Alt+Return".action.spawn = "alacritty";
        "Alt+Shift+Return".action.spawn = "fuzzel";
        "Shift+Alt+L".action.spawn = "swaylock -f image ~/Pictures/wallpaper-master/nixos.png --clock";
        "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
        "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
        "XF86AudioMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        "XF86AudioMicMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];

        # Everything regarding windows
        "Alt+Ctrl+C".action = close-window;
        "Alt+Left".action = focus-column-left;
        "Alt+Right".action = focus-column-right;
        "Alt+Up".action = focus-window-up;
        "Alt+Down".action = focus-window-down;
        "Alt+Shift+Left".action = move-column-left;
        "Alt+Shift+Right".action = move-column-right;
        "Alt+Shift+Up".action = move-window-up;
        "Alt+Shift+Down".action = move-window-down;

        # Workspaces and monitors
        "Alt+Ctrl+Down".action = move-workspace-down;
        "Alt+Ctrl+Up".action = move-workspace-up;
        "Alt+Ctrl+Left".action = focus-monitor-left;
        "Alt+Ctrl+Right".action = focus-monitor-right;
        "Alt+Shift+Ctrl+Left".action  =  move-window-to-monitor-left;
        "Alt+Shift+Ctrl+Right".action =  move-window-to-monitor-right;
        "Mod+Alt+Shift+Ctrl+Left".action  = move-column-to-monitor-left;
        "Mod+Alt+Shift+Ctrl+Right".action = move-column-to-monitor-right;      
        "Alt+1".action = focus-workspace 1; 
        "Alt+2".action = focus-workspace 2; 
        "Alt+3".action = focus-workspace 3; 
        "Alt+4".action = focus-workspace 4; 
        "Alt+5".action = focus-workspace 5; 
        "Alt+6".action = focus-workspace 6; 
        "Alt+7".action = focus-workspace 7; 
        "Alt+8".action = focus-workspace 8; 
        "Alt+9".action = focus-workspace 9; 
        "Alt+Shift+1".action = move-column-to-workspace 1;
        "Alt+Shift+2".action = move-column-to-workspace 2;
        "Alt+Shift+3".action = move-column-to-workspace 3;
        "Alt+Shift+4".action = move-column-to-workspace 4;
        "Alt+Shift+5".action = move-column-to-workspace 5;
        "Alt+Shift+6".action = move-column-to-workspace 6;
        "Alt+Shift+7".action = move-column-to-workspace 7;
        "Alt+Shift+8".action = move-column-to-workspace 8;
        "Alt+Shift+9".action = move-column-to-workspace 9;
        "Alt+Ctrl+1".action = move-window-to-workspace 1;
        "Alt+Ctrl+2".action = move-window-to-workspace 2;
        "Alt+Ctrl+3".action = move-window-to-workspace 3;
        "Alt+Ctrl+4".action = move-window-to-workspace 4;
        "Alt+Ctrl+5".action = move-window-to-workspace 5;
        "Alt+Ctrl+6".action = move-window-to-workspace 6;
        "Alt+Ctrl+7".action = move-window-to-workspace 7;
        "Alt+Ctrl+8".action = move-window-to-workspace 8;
        "Alt+Ctrl+9".action = move-window-to-workspace 9;

        # Column and Window stuff
        "Alt+Comma".action = consume-window-into-column;
        "Alt+Period".action = expel-window-from-column;
        "Alt+R".action = switch-preset-column-width;
        "Alt+Shift+R".action = reset-window-height;
        "Alt+Space".action = fullscreen-window;
        "Alt+Shift+Space".action = maximize-column;
        "Alt+C".action = center-column;
        "Alt+Plus".action = set-window-height "+10%";
        "Alt+Equals".action = set-window-height "+10%";
        "Alt+Minus".action = set-window-height "+-10%";

        # Screenshots, Monitor off and Exit
        "Alt+Shift+Q".action = quit;
        "Alt+Shift+P".action = power-off-monitors;
        "Print".action = screenshot;
        "Ctrl+Print".action = screenshot-screen;
        "Alt+Print".action = screenshot-window;
       };
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
}
