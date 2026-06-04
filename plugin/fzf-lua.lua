local config = require('config')
local fzf = require('fzf-lua')
fzf.setup({
  keymap = {
    fzf = {
      ["ctrl-a"] = "select-all+accept",
    }
  }
})

-- can replace with custom findexpr function use fd, pipe results out to custom vim.ui.select
-- can also replace with fzf basic vim
vim.keymap.set('n', config.fzf_lua.prioritize_fzf_lua_files and '<leader><leader>' or config.fzf_lua.fzf_lua_leader .. 'f', function()
    fzf.files({
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
-- can replace with custom findexpr function? look at buffers, use fd, pipe results out to custom vim.ui.select
vim.keymap.set('n', config.fzf_lua.prioritize_fzf_lua_buffers and '<leader>b' or config.fzf_lua.fzf_lua_leader .. 'b', function()
    fzf.buffers({
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
vim.keymap.set('n', config.fzf_lua.fzf_lua_leader .. 's', fzf.git_status)

-- fzf grep stuff.
vim.keymap.set('n', config.fzf_lua.prioritize_fzf_lua_grep and '<leader>gr' or config.fzf_lua.fzf_lua_leader .. 'g', fzf.grep)
vim.keymap.set('v', config.fzf_lua.prioritize_fzf_lua_grep and '<leader>8' or config.fzf_lua.fzf_lua_leader .. '8', fzf.grep_visual)

-- fzf lsp stuff.
vim.keymap.set('n', config.fzf_lua.fzf_lua_leader .. '[', fzf.lsp_references)
vim.keymap.set("n", config.fzf_lua.fzf_lua_leader .. "d", fzf.diagnostics_document)

-- fzf nice to haves
vim.keymap.set('n', config.fzf_lua.fzf_lua_leader .. 'c', fzf.colorschemes)

fzf.register_ui_select()
