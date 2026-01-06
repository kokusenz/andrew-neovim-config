require('andrewgil')
local Plug = vim.fn['plug#']

vim.call('plug#begin')
-- Language Server related plugins
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/vim-vsnip')
Plug('hrsh7th/cmp-vsnip')
Plug('https://github.com/Hoffs/omnisharp-extended-lsp.nvim.git')
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
-- searching
Plug('ibhagwan/fzf-lua')
--Plug('/home/agil/code/deltaview.nvim.git/main')
Plug('kokusenz/deltaview.nvim')
-- nice to haves
Plug('fabijanzulj/blame.nvim')
-- color schemes
Plug('sainnhe/gruvbox-material')
Plug('lifepillar/vim-solarized8')
Plug('shaunsingh/nord.nvim')
Plug('catppuccin/nvim')
Plug('folke/tokyonight.nvim')
Plug('bluz71/vim-moonfly-colors')
Plug('rose-pine/neovim', {['as'] = 'rose-pine'})

vim.call('plug#end')

require('statusline')
require('colorscheme')
require('searching')
require('lsp')
require('make')
require('blametoggle')
require('fzf').setup_fzf_lua()
require('vimuiselect').setup()
