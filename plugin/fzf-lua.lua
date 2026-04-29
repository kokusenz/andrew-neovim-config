local fzf = require('fzf-lua')
fzf.setup({
  keymap = {
    fzf = {
      ["alt-a"]         = "select-all+accept",
    }
  }
})

-- can replace with custom findexpr function use fd, pipe results out to custom vim.ui.select
-- can also replace with fzf basic vim
vim.keymap.set('n', '<C-.>f', fzf.files)
-- can replace with custom findexpr function? look at buffers, use fd, pipe results out to custom vim.ui.select
vim.keymap.set('n', '<C-.>b', fzf.buffers)
vim.keymap.set('n', '<C-.>s', fzf.git_status)

-- fzf grep stuff.
vim.keymap.set('n', '<C-.>g', fzf.grep)

-- fzf lsp stuff.
vim.keymap.set('n', '<C-.>[', fzf.lsp_references)
vim.keymap.set("n", "<C-.>d", fzf.diagnostics_document)

-- fzf nice to haves
vim.keymap.set('n', '<C-.>c', fzf.colorschemes)

fzf.register_ui_select()
