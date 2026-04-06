local M = {}

--- Setup configuration and keymaps for fzf-lua plugin
--- Configures fzf-lua with custom keymaps and sets up extensive keybindings for:
--- - File/buffer navigation
--- - Git integration
--- - Grep/search functionality
--- - LSP features
--- - Diagnostics and utilities
M.setup_fzf_lua = function()
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
    vim.keymap.set('n', '<leader>gl', fzf.live_grep)

    -- fzf lsp stuff. Generally, if I could benefit from the preview or the search, it's worth using this over vim.lsp.buf.
    -- add outgoing_calls and incoming_calls ; generally subsets of find references, but can be helpful
    vim.keymap.set('n', '<leader>fr', fzf.lsp_references,
      { noremap = true, silent = true, desc = 'LSP references' })
    vim.keymap.set('n', '<leader>gi', fzf.lsp_implementations,
      { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>db", fzf.diagnostics_document)
    vim.keymap.set("n", "<leader>dw", fzf.diagnostics_workspace)

    -- fzf nice to haves
    vim.keymap.set('n', '<leader>cs', fzf.colorschemes)
    vim.keymap.set('n', '<leader>co', fzf.quickfix)
end

return M
