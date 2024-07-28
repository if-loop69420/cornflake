{ config, pkgs, ... }:

let 
  customNvim = import ./nvim/nvim.nix;
  customZsh = import ./zsh.nix;
  customHelix = import ./helix.nix;
  customNiri = import ./niri.nix;
  customEmacs = import ./emacs/emacs.nix;
in 
{
  home.stateVersion="24.05";
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
    xwayland-satellite
  ];

  programs.zoxide = {
    enable = true;
    # enableNushellIntegration = true;
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
}
