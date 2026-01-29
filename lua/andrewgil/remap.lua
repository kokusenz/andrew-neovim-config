vim.g.mapleader = " "
vim.keymap.set('n', '-', function() vim.cmd("Oil") end)

-- pane navigation, pane resizing
vim.keymap.set('n', '<leader>wl', '<C-w>l', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>wh', '<C-w>h', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>w0', '<C-w>=', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>w-', '12<C-w><', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>w=', '12<C-w>>', { silent = true, noremap = true })

-- makes vertical nav a bit cleaner
vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true, noremap = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true, noremap = true })

-- quickfix list nav bindings
vim.keymap.set('n', '<leader>cn', vim.cmd.cnext)
vim.keymap.set('n', '<leader>cp', vim.cmd.cprev)
