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
vim.keymap.set('n', '<leader><leader>', fzf.files)
-- can replace with custom findexpr function? look at buffers, use fd, pipe results out to custom vim.ui.select
vim.keymap.set('n', '<leader>bf', fzf.buffers)
vim.keymap.set('n', '<leader>gs', fzf.git_status)
vim.keymap.set('n', '<leader>gc', fzf.git_commits)

-- fzf grep stuff.
vim.keymap.set('n', '<leader>gr', fzf.grep)
vim.keymap.set('n', '<leader>ga', ":lua FzfLua.grep({resume=true})<cr>")
vim.keymap.set('v', '<leader>8', fzf.grep_visual)

-- fzf lsp stuff. Generally, if I could benefit from the preview or the search, it's worth using this over vim.lsp.buf
-- These are the default keybinds, just overriding them with the fzf versions
vim.keymap.set('n', '<C-]>', fzf.lsp_definitions)
vim.keymap.set('n', 'grr', fzf.lsp_references)
vim.keymap.set('n', 'gri', fzf.lsp_implementations)
-- the below are not default keybinds, but are unused, and just follow the pattern of g + r + first letter
vim.keymap.set("n", "grb", fzf.diagnostics_document)
vim.keymap.set("n", "grw", fzf.diagnostics_workspace)

-- fzf nice to haves
vim.keymap.set('n', '<leader>cs', fzf.colorschemes)
vim.keymap.set('n', '<leader>co', fzf.quickfix)
