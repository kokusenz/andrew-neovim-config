--- options for common options that will change from computer to computer
--- this way, the diff will sit in one file
--- technically can gitignore, but I prefer for this to be visible
--- @class NvimOpts
local M = {
    autocomplete = false,
    enable_osc_yank = false,
    lazy_dotnet = true,
    -- note that catppuccin is overriden with custom colorscheme; mocha has darker background, latte/frappe/macchiato are "blueberry"
    colorscheme = {
        --- @type 'catppuccin' | 'catppuccin-mocha' | 'catppuccin-latte' | 'catppuccin-frappe' | 'catppuccin-macchiato' | 'tokyonight' | 'tokyonight-day' | 'tokyonight-moon' | 'tokyonight-night' | 'tokyonight-storm' | 'moonfly' | 'solarized8' | 'solarized8_low' | 'solarized8_flat' | 'solarized8_high' | 'gruvbox-material' | 'rose-pine' | 'rose-pine-dawn' | 'rose-pine-main' | 'rose-pine-moon'
        name = 'moonfly',
        -- solarized doesn't respond to transparent value
        transparent = true,
    },
    fzf_lua = {
        fzf_lua_leader = '<C-.>',
        prioritize_fzf_lua_files = true,
        prioritize_fzf_lua_buffers = true,
        prioritize_fzf_lua_grep = false,
        prioritize_fzf_lua_git_status = true,
    },
    --- possible files
    --- vim.api.nvim_get_runtime_file('lua/delta', true)
    --- { '/usr/share/hypr/stubs/' }
    --- @type string[][]
    runtime_files = {{ '/usr/share/hypr/stubs/' }, { '/home/agil/.luarocks/share/lua/5.5/' } },
}

-- vim.opt.runtimepath:append('/home/agil/code/deltaview.nvim.git/documentation')
-- vim.opt.runtimepath:append('/home/agil/code/deltaview.nvim.git/documentation/after')
-- vim.opt.runtimepath:append('/home/agil/code/delta.lua.git/archive-delta-lua')
-- vim.opt.runtimepath:append('/home/agil/code/delta.lua.git/archive-delta-lua/after')
-- vim.opt.runtimepath:append('/home/agil/code/nvim-reference-repos/telescope.nvim/')
-- vim.opt.runtimepath:append('/home/agil/code/nvim-reference-repos/telescope.nvim/after')

return M
