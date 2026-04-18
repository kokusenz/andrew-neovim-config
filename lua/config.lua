--- options for common options that will change from computer to computer
--- this way, the diff will sit in one file
--- technically can gitignore, but I prefer for this to be visible
--- @class NvimOpts
local M = {
    -- note that catppuccin is overriden with custom colorscheme; mocha has darker background, latte/frappe/macchiato are "blueberry"
    colorscheme = {
        --- @type 'catppuccin' | 'catppuccin-mocha' | 'catppuccin-latte' | 'catppuccin-frappe' | 'catppuccin-macchiato' | 'tokyonight' | 'tokyonight-day' | 'tokyonight-moon' | 'tokyonight-night' | 'tokyonight-storm' | 'moonfly' | 'solarized8' | 'solarized8_low' | 'solarized8_flat' | 'solarized8_high' | 'gruvbox-material'
        name = 'catppuccin-mocha',
        -- solarized doesn't respond to transparent value
        transparent = true,
    },
    codecompanion = {
        model = 'sonnet-4.6'
    }
}

return M
