local ocs = require('config').options.colorscheme

require("catppuccin").setup({
    transparent_background = ocs.transparent,
    flavour = 'mocha'
})

require("kanagawa").setup({
    transparent = ocs.transparent,
    colors = { theme = { all = { ui = { bg_gutter = "none" } } } }
})

vim.g.moonflyTransparent = ocs.transparent
vim.g.moonflyVirtualTextColor = true

vim.cmd('silent! colorscheme ' .. ocs.plugin_colorscheme_name)
