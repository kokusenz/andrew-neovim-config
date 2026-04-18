vim.g.mapleader = " "
vim.keymap.set('n', '-', function() vim.cmd("Ex") end)

vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { silent = true, noremap = true })
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { silent = true, noremap = true })

-- pane resizing
vim.keymap.set('n', '<C-w>0', '<C-w>=', { silent = true, noremap = true })
vim.keymap.set('n', '<C-w>-', '12<C-w><', { silent = true, noremap = true })
vim.keymap.set('n', '<C-w>=', '12<C-w>>', { silent = true, noremap = true })

-- makes vertical nav a bit cleaner
vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true, noremap = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true, noremap = true })

-- quickfix list nav bindings
vim.keymap.set('n', '<leader>cq', vim.cmd.cclose)
vim.keymap.set('n', '<leader>q', vim.cmd.copen)
