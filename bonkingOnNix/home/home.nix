{ config, pkgs, ... }:

let 
  customNvim = import ./nvim/nvim.nix;
  customZsh = import ./zsh.nix;
  customSway = import ./sway.nix;
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
    ];
  };


  programs.tmux = {
    enable = true;
    clock24 = true;
    shortcut = "a";
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

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty"; 
      startup = [
        # Launch Firefox on start
        {command = "firefox";}
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    recommendedEnvironment = true;
    systemdIntegration = true;
    nvidiaPatches = true;
    extraConfig = ''
      input {
        kb_layout = de

        follow_mouse = 1
        force_no_accel = true
      }

      general {
        gaps_in = 6
        gaps_out = 15
        col.active_border = rgb(f5c2e7)
        col.inactive_border = rgb(6c7086)

        layout = dwindle
      }

      decoration {

        rounding = 8

        #blur
        blur = yes
        blur_size = 5
        blur_passes = 3
        blur_new_optimizations = on
        multisample_edges = true

        #opactity
        inactive_opacity = 1.0
        active_opacity = 1.0
        fullscreen_opacity = 1.0

        # shadow
        drop_shadow = yes
        shadow_range = 60
        shadow_offset = 0 5
        shadow_render_power = 4
        col.shadow = rgba(00000099)
      }

      dwindle {

        pseudotile = yes
        preserve_split = yes
      }

      animations {

        enabled = yes

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
      }

      master {
        new_is_master = true
      }

      gestures {
        workspace_swipe = on
      }

      exec-once = wl-paste -t text --watch clipman store --no-persist
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = WLR_NO_HARDWARE_CURSORS,1


      $mainMod = ALT
      bind = $mainMod, Return, exec, alacritty
      bind = $mainMod, Q, killactive,
      bind = $mainMod SHIFT, L, exec, swaylock
      bind = $mainMod, P, pseudo

      bind = $mainMod, V, togglesplit, # dwindle
      bind = $mainMod, SPACE, exec, wofi --show drun
      bind = $mainMod SHIFT, Q, exec, hyprctl dispatch exit

      bind = $mainMod, H, movefocus, l
      bind = $mainMod, L, movefocus, r
      bind = $mainMod, J, movefocus, d
      bind = $mainMod, K, movefocus, u

      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1
    '';
  };

  programs.waybar = {
    enable = true;
  };

  programs.rofi = {
    package = pkgs.rofi-wayland;
    enable = true;
  };


}
