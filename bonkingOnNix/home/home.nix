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

  programs.git = {
    enable = true;
    userName = "if-loop69420";
    userEmail = "j.sztavi@pm.me";
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
    newSession = true;
    secureSocket=true;
  };

}
