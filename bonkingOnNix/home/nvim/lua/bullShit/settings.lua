require('plugins')

local o = vim.o 
local g = vim.g

local stdW = 2 --standard width 
g.mapleader = "," 
o.smarttab = true
o.smartindent = true
o.shiftwidth = stdW
o.tabstop = stdW 
o.softtabstop = stdW
o.expandtab = true
o.cindent = true

o.number = true
o.numberwidth = 5
o.relativenumber = true
o.signcolumn = 'yes:2'
o.cursorline = true

o.list = true
o.listchars = 'trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂'

o.scrolloff = 8

o.timeoutlen = 500
o.updatetime = 200

o.history = 50

-- Better buffer splitting
o.splitright = true
o.splitbelow = true

o.clipboard = 'unnamedplus'

--[[local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
]]--
