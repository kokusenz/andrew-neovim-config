local catppuccin = require("catppuccin")
catppuccin.setup({
  transparent_background = true,
})

require("tokyonight").setup({
  transparent = true
})

require("rose-pine").setup({
  variant = 'main',
  dark_variant = 'main',
  styles = {
    transparency = false,
  }
})

vim.background = 'dark'
vim.g.moonflyTransparent = true
vim.g.moonflyVirtualTextColor = true
vim.g.solarized_termtrans = 1
vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_material_background = 'hard'

vim.cmd('silent! colorscheme gruvbox-material')
