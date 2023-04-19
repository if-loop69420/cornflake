pkgs: 

{
  enable = true;
  viAlias = true;
  plugins = with pkgs.vimPlugins; [
    vim-nix
    nerdtree
    indentLine
    nvim-web-devicons
    nvim-treesitter
    catppuccin-nvim
    plenary-nvim
    leap-nvim
    {
      plugin = telescope-nvim;
      config = ''
        nnoremap <leader>ff <cmd>Telescope find_files<cr>
        nnoremap <leader>fg <cmd>Telescope live_grep<cr>
        nnoremap <leader>fb <cmd>Telescope buffers<cr>
        nnoremap <leader>fh <cmd>Telescope help_tags<cr>
      '';
    }
    {
      plugin=packer-nvim;
    }
  ];

  extraConfig = '' 
    luafile $HOME/.config/nixpkgs/nvim/init.lua
     " Show hover
    nnoremap K <Cmd>lua vim.lsp.buf.hover()<CR>
     " Jump to definition
    nnoremap gd <Cmd>lua vim.lsp.buf.definition()<CR>
     " Open code actions using the default lsp UI, if you want to change this please see the plugins above
    nnoremap <leader>ca <Cmd>lua vim.lsp.buf.code_action()<CR>
     " Open code actions for the selected visual range
    xnoremap <leader>ca <Cmd>lua vim.lsp.buf.range_code_action()<CR>
    colorscheme "catppuccing-mocha"
  '';
}
