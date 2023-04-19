pkgs: 

let

in
{
  enable = true;
  shellAliases = {
    ll = "ls -l";
    ns = "nix --experimental-features 'nix-command flakes' search nixpkgs";
  };
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" "rust" "z"];
  };
  zplug = {
    enable = true;
    plugins = [
      { name = "zsh-users/zsh-autosuggestions"; }
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
    '';
}
