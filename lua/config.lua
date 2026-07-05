local M = {}

--- options for common options that will change from computer to computer
--- this way, the diff will sit in one file
--- technically can gitignore, but I prefer for this to be visible
--- @class NvimOpts
M.defaults = {
    autocomplete = false,
    enable_unnamed_plus_paste = false,
    lazy_dotnet = true,
    -- note that catppuccin is overriden with custom colorscheme; mocha has darker background, latte/frappe/macchiato are "blueberry"
    colorscheme = {
        --- @type 'catppuccin' | 'catppuccin-mocha' | 'catppuccin-latte' | 'catppuccin-frappe' | 'catppuccin-macchiato' | 'tokyonight' | 'tokyonight-day' | 'tokyonight-moon' | 'tokyonight-night' | 'tokyonight-storm' | 'moonfly' | 'solarized8' | 'solarized8_low' | 'solarized8_flat' | 'solarized8_high' | 'gruvbox-material' | 'rose-pine' | 'rose-pine-dawn' | 'rose-pine-main' | 'rose-pine-moon' | 'default'
        plugin_colorscheme_name = 'default',
        -- solarized should not respond to transparent value, to allow to solarize
        default_colorscheme_name = 'default',
        transparent = true,
    },
    fzf_lua = {
        fzf_lua_leader = '<C-.>',
        prioritize_fzf_lua_files = false,
        prioritize_fzf_lua_buffers = false,
        prioritize_fzf_lua_grep = false,
        prioritize_fzf_lua_git_status = false,
    },
    fzy = {
        ---@alias Position 'center' | 'bottom' | 'top'
        ---@type Position
        position = 'center',
        prioritize_fzy_files = true,
    },
    --- possible files
    --- vim.api.nvim_get_runtime_file('lua/delta', true)
    --- { '/usr/share/hypr/stubs/' }
    --- @type string[][]
    runtime_files = { vim.api.nvim_get_runtime_file('lua/delta', true) }, -- lua/mini.test, if minitest is installed
}

M.options = vim.deepcopy(M.defaults)

--- @class NvimOpts
M.setup = function(opts)
    M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
