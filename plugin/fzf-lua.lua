local opts = require('config').options

local fzf
local function load_fzf()
    if fzf then return fzf end
    fzf = require('fzf-lua')
    fzf.setup({
        keymap = {
            fzf = {
                ["ctrl-a"] = "select-all+accept",
            }
        }
    })
    return fzf
end

local leader = opts.fzf_lua.fzf_lua_leader

vim.keymap.set('n', opts.fzf_lua.prioritize_fzf_lua_files and '<leader><leader>' or leader .. 'f', function()
    load_fzf().files({
        previewer = false,
        fzf_opts = {
            ['--layout'] = 'default',
        },
        winopts = {
            height = 0.35,
            row = 0.9,
            border = 'single'
        }
    })
end)

vim.keymap.set('n', opts.fzf_lua.prioritize_fzf_lua_buffers and '<leader>b' or leader .. 'b', function()
    load_fzf().buffers({
        previewer = false,
        fzf_opts = {['--layout'] = 'default'},
        ignore_current_buffer = false,
        winopts = {
            height = 0.40,
            row = 0.9,
            border = 'single'
        }
    })
end)

vim.keymap.set('n', opts.fzf_lua.prioritize_fzf_lua_git_status and '<leader>s' or leader .. 's', function()
    load_fzf().git_status({
        previewer = false,
        fzf_opts = {['--layout'] = 'default'},
        ignore_current_buffer = false,
        winopts = {
            height = 0.35,
            row = 0.9,
            border = 'single'
        }
    })
end)

vim.keymap.set('n', opts.fzf_lua.prioritize_fzf_lua_grep and '<leader>gr' or leader .. 'g', function() load_fzf().grep() end)
vim.keymap.set('v', opts.fzf_lua.prioritize_fzf_lua_grep and '<leader>8' or leader .. '8', function() load_fzf().grep_visual() end)

vim.keymap.set('n', leader .. '[', function() load_fzf().lsp_references() end)
vim.keymap.set('n', leader .. 'd', function() load_fzf().diagnostics_document() end)

vim.keymap.set('n', leader .. 'c', function() load_fzf().colorschemes() end)
