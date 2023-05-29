pkgs: 

{
  enable = true;
  viAlias = true;
  extraConfig = '' 
    luafile $HOME/.config/dotfiles/bonkingOnNix/home/nvim/init.lua
  '';
}
