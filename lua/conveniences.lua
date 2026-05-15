vim.g.mapleader = " "
vim.keymap.set('n', '-', function() vim.cmd("Ex") end)

local enable_osc_yank = require('config').enable_osc_yank
if enable_osc_yank then
    vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
            ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
            ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
        },
    }
end
-- keybinds to use system keyboard
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
