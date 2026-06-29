vim.g.mapleader = " "

local opts = require('config').options
if not opts.enable_unnamed_plus_paste then vim.g.clipboard = 'osc52' end
-- keybinds to use system keyboard
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { silent = true, noremap = true })
if opts.enable_unnamed_plus_paste then
    vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { silent = true, noremap = true })
end

-- pane resizing
vim.keymap.set('n', '<C-w>0', '<C-w>=', { silent = true, noremap = true })
vim.keymap.set('n', '<C-w>-', '12<C-w><', { silent = true, noremap = true })
vim.keymap.set('n', '<C-w>=', '12<C-w>>', { silent = true, noremap = true })

-- makes vertical nav a bit cleaner
vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true, noremap = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true, noremap = true })

-- quickfix list nav bindings
vim.keymap.set('n', '<Del>', vim.cmd.cclose)
vim.keymap.set('n', '<leader>q', vim.cmd.copen)

-- make for cs files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    --vim.bo.makeprg = "dotnet build" -- this doesn't work lol
    vim.cmd("let dotnet_errors_only = v:true")
    vim.cmd("let dotnet_show_project_file = v:false")
    vim.cmd("compiler dotnet")
  end,
  desc = "Set dotnet compiler for C# files"
})

-- term
vim.cmd([[cabbrev te \| term ]])
vim.keymap.set('n', '<leader>e', ':sp | term ')

vim.api.nvim_create_user_command('YankRelPath', function()
    local path = vim.fn.expand('%:.')
    vim.fn.setreg('+', path)
    vim.notify('Yanked: ' .. path .. ' to register +', vim.log.levels.INFO)
end, { desc = 'Yank relative path of current buffer to specified register' })
