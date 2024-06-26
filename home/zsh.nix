pkgs: 

let

in
{
  enable = true;
  shellAliases = {
    ll = "ls -l";
    ns = "nix --experimental-features 'nix-command flakes' search nixpkgs";
    sys-rebuild = "sudo nixos-rebuild switch --flake '/home/jeremy/.config/dotfiles/#bonkingOnNix'";
    nvim = "lvim";
  };
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" "rust" "z" "tmux" ];
  };
  zplug = {
    enable = true;
    plugins = [
      { name = "zsh-users/zsh-autosuggestions"; }
      { name = "zsh-users/zsh-history-substring-search";}
      { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1]; }
      { name = "dracula/zsh"; tags= [ as:theme depth:2]; }
      { name = "zsh-users/zsh-syntax-highlighting"; }
    ];
  };
  envExtra = '' 
    source /home/jeremy/.p10k.zsh 
    export PATH="$PATH:/home/jeremy/.mix/escripts"
    export PATH="$PATH:/home/jeremy/.surrealdb/"
    export PATH="$PATH:/home/jeremy/.emacs.d/bin"
    export PATH="$PATH:${pkgs.rustc}"
    export PATH="$PATH:${pkgs.rustup}"
    export PATH="$PATH:${pkgs.clang}"
    export PATH="$PATH:${pkgs.gcc}"
    export PATH=/home/jeremy/.local/bin:$PATH
    export TERM=tmux-256color

    export NVM_LAZY_LOAD=true
    export NMV_COMPLETION=true
    '';

  initExtraFirst = '' 
    if [ "$TMUX" = "" ]; then tmux; fi
    # eval "$(direnv hook zsh)"
    pfetch
  '';
}
