vim.wo.relativenumber = true
-- keybinds to use system keyboard
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { silent = true, noremap = true })
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { silent = true, noremap = true })
vim.opt.tabstop       = 4  -- literal <Tab> == 4 spaces when files are read
vim.opt.shiftwidth    = 4  -- >> << == 4 spaces
vim.opt.softtabstop   = 4  -- <Tab> while typing feels like 4 spaces
vim.opt.expandtab     = true -- convert <Tab> presses to spaces (optional)
vim.opt.background    = 'dark'
vim.opt.termguicolors = true
vim.opt.ignorecase    = true
vim.opt.smartcase     = true
