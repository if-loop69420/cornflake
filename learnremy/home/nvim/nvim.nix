pkgs: 

{
  enable = true;
  plugins = with pkgs.vimPlugins; [
    nvim-treesitter
  ];
}
