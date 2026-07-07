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
vim.cmd([[cabbrev te \| term]])
vim.cmd([[cabbrev vb \| let $b=expand('%:p')]])
vim.keymap.set('n', '<leader>e', [[:sp | let $b=expand('%:p') | term ]])
vim.keymap.set('n', '<leader>w', function()
    vim.cmd([[:let $b=expand('%:p') | term jj diff --no-pager -- $b]])
end)

vim.keymap.set('n', '<leader>j', function()
    local result = vim.system({'jj', 'diff', '--name-only'}):wait()
    if not result.stdout then
        print('idk, jj diff failed')
        return
    end
    local items = vim.split(result.stdout, "\n", { trimempty = true})
    vim.print(items)
    vim.ui.select(items, {}, function(item)
        if not item then
            return
        end
        vim.cmd('e ' .. vim.fn.fnameescape(item))
    end)
end)

-- git
vim.keymap.set('n', 'gsa', function()
    vim.cmd([[:!git add %]])
    local result = vim.system({'git', 'status', '--short'}):wait()
    if result.code == 0 then
        vim.notify(result.stdout, vim.log.levels.TRACE)
    end
end)

vim.api.nvim_create_user_command('YankRelPath', function()
    local path = vim.fn.expand('%:.')
    vim.fn.setreg('+', path)
    vim.notify('Yanked: ' .. path .. ' to register +', vim.log.levels.INFO)
end, { desc = 'Yank relative path of current buffer to specified register' })
