--- options for common options that will change from computer to computer
--- this way, the diff will sit in one file
--- technically can gitignore, but I prefer for this to be visible
--- @class NvimOpts
local M = {
    autocomplete = false,
    lazy_dotnet = true,
    --- @type 'sonnet' | 'opus' | 'ollama_hybrid' | 'ollama'
    codecompanion = 'sonnet',
    -- note that catppuccin is overriden with custom colorscheme; mocha has darker background, latte/frappe/macchiato are "blueberry"
    colorscheme = {
        --- @type 'catppuccin' | 'catppuccin-mocha' | 'catppuccin-latte' | 'catppuccin-frappe' | 'catppuccin-macchiato' | 'tokyonight' | 'tokyonight-day' | 'tokyonight-moon' | 'tokyonight-night' | 'tokyonight-storm' | 'moonfly' | 'solarized8' | 'solarized8_low' | 'solarized8_flat' | 'solarized8_high' | 'gruvbox-material' | 'rose-pine' | 'rose-pine-dawn' | 'rose-pine-main' | 'rose-pine-moon'
        name = 'catppuccin-mocha',
        -- solarized doesn't respond to transparent value
        transparent = true,
    },
    api_keys = {
        ollama_cloud = ""
    }
}

return M
