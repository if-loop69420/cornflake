package.path = package.path .. ";/home/jeremy/.config/nixpkgs/nvim/lua/bullShit/?.lua"

require('settings')
require('plugins')

local function map(m, k, v)
  vim.keymap.set(m,k,v, { silent = true })
end
