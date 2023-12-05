{ config, pkgs, ... }:

let 
  customNvim = import ./nvim/nvim.nix;
  customZsh = import ./zsh.nix;
  customHelix = import ./helix.nix;
in 
{
  home.stateVersion="23.05";
  home.username="jeremy";
  home.homeDirectory="/home/jeremy";
  programs.neovim = customNvim pkgs;
  programs.zsh = customZsh pkgs;
  programs.helix = customHelix pkgs;
  home.packages = with pkgs;[
    gnomeExtensions.material-you-color-theming
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
  ];

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "if-loop69420";
    userEmail = "j.sztavi@pm.me";
  };

  programs.nushell = {
    enable = true;
    extraConfig = '' 
      let-env config = {
        show_banner: false
      }

      alias sys-rebuild = sudo nixos-rebuild switch --flake '/home/jeremy/.config/dotfiles/#'
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
