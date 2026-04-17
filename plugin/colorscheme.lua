local catppuccin_opts = ({
    transparent_background = false,
    flavour = 'mocha'
})
catppuccin_opts = vim.tbl_deep_extend('force', catppuccin_opts, require('blueberry_peach').get_overrides('mocha'))
catppuccin_opts = vim.tbl_deep_extend('force', catppuccin_opts, require('blueberry_peach').get_overrides('frappe'))
catppuccin_opts = vim.tbl_deep_extend('force', catppuccin_opts, require('blueberry_peach').get_overrides('macchiato'))
catppuccin_opts = vim.tbl_deep_extend('force', catppuccin_opts, require('blueberry_peach').get_overrides('latte'))
require("catppuccin").setup(catppuccin_opts)

require("tokyonight").setup({
    transparent = true
})

require("rose-pine").setup({
    variant = 'main',
    dark_variant = 'main',
    styles = {
        transparency = false,
        italic = false
    }
})

vim.background = 'dark'
vim.g.moonflyTransparent = true
vim.g.moonflyVirtualTextColor = true
vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_material_background = 'hard'

vim.cmd([[silent! colorscheme catppuccin]])
