local M = {}

--- options for common options that will change from computer to computer
--- this way, the diff will sit in one file
--- technically can gitignore, but I prefer for this to be visible
--- @class CustomOpts
M.defaults = {
    autocomplete = false,
    enable_unnamed_plus_paste = false,
    lazy_dotnet = true,
    -- note that catppuccin is overriden with custom colorscheme; mocha has darker background, latte/frappe/macchiato are "blueberry"
    --- @class CustomOptsColorscheme
    colorscheme = {
        --- @type 'catppuccin' | 'catppuccin-mocha' | 'catppuccin-latte' | 'catppuccin-frappe' | 'catppuccin-macchiato' | 'moonfly' | 'kanagawa-wave' | 'kanagawa-dragon' | 'kanagawa-lotus' | 'default'
        plugin_colorscheme_name = 'kanagawa-wave',
        -- solarized should not respond to transparent value, to allow to solarize
        default_colorscheme_name = 'retrobox',
        transparent = true,
    },
    --- @class CustomOptsKeyConfig
    keyconfig = {
        --- @type KeyConfig
        files = {
            modes = 'n',
            lhs = "<leader><leader>",
            custom = false
        },
        --- @type KeyConfig
        buffers = {
            modes = 'n',
            lhs = "<leader>b",
            custom = false
        },
        --- @type KeyConfig
        grep = {
            modes = 'n',
            lhs = "<leader>gr",
            custom = false
        },
        --- @type KeyConfig
        visual_grep = {
            modes = 'v',
            lhs = "<leader>8",
            custom = false
        },
    },
    ---@alias Position 'center' | 'bottom' | 'top'
    ---@type Position
    popup_position = 'bottom',
    --- possible files
    --- vim.api.nvim_get_runtime_file('lua/delta', true)
    --- { '/usr/share/hypr/stubs/' }
    --- @type string[][]
    runtime_files = { vim.api.nvim_get_runtime_file('lua/delta', true) }, -- lua/mini.test, if minitest is installed
}

M.options = vim.deepcopy(M.defaults)

--- sets a switchable keymap; if config leans default; then this won't trigger
--- this is just so that in code i don't have to write if config then keymap.set
--- @param config KeyConfig  Right-hand side |{rhs}| of the mapping, can be a Lua function.
--- @param custom boolean indicating this is custom behavior
--- @param rhs string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
M.set_keymap = function(config, custom, rhs)
    if config.custom == custom then
        vim.keymap.set(config.modes, config.lhs, rhs, config.opts)
    end
end

--- @class CustomOpts
M.setup = function(opts)
    M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M

--- If there is not a default, this, i guess setting default to false just disables it
--- @class KeyConfig
--- @field modes string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
--- @field lhs string|string[]  Left-hand side |{lhs}| of the mapping, or a list thereof.
--- @field opts? vim.keymap.set.Opts
--- @field custom boolean if false, then use default behavior
