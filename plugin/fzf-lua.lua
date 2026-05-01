local fzf = require('fzf-lua')
fzf.setup({
  keymap = {
    fzf = {
      ["alt-a"]         = "select-all+accept",
    }
  }
})
local config = require('config')

-- can replace with custom findexpr function use fd, pipe results out to custom vim.ui.select
-- can also replace with fzf basic vim
vim.keymap.set('n', config.fzf_lua_leader .. 'f', fzf.files)
-- can replace with custom findexpr function? look at buffers, use fd, pipe results out to custom vim.ui.select
vim.keymap.set('n', config.fzf_lua_leader .. 'b', fzf.buffers)
vim.keymap.set('n', config.fzf_lua_leader .. 's', fzf.git_status)

-- fzf grep stuff.
vim.keymap.set('n', config.fzf_lua_leader .. 'g', fzf.grep)

-- fzf lsp stuff.
vim.keymap.set('n', config.fzf_lua_leader .. '[', fzf.lsp_references)
vim.keymap.set("n", "<C-.>d", fzf.diagnostics_document)

-- fzf nice to haves
vim.keymap.set('n', config.fzf_lua_leader .. 'c', fzf.colorschemes)

fzf.register_ui_select()
