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
vim.keymap.set('n', '<leader>e', [[:sp | let $b=expand('%:p') | term ]])

vim.keymap.set('t', '<C-b>h', '<C-\\><C-n><C-w>h', { silent = true, noremap = true })
vim.keymap.set('t', '<C-b>j', '<C-\\><C-n><C-w>j', { silent = true, noremap = true })
vim.keymap.set('t', '<C-b>k', '<C-\\><C-n><C-w>k', { silent = true, noremap = true })
vim.keymap.set('t', '<C-b>l', '<C-\\><C-n><C-w>l', { silent = true, noremap = true })

-- vcs
vim.keymap.set('n', '<leader>w', function()
    vim.cmd([[:let $b=expand('%:p') | term jj diff --no-pager -- $b]])
end)

local jj_diff_select = function()
        local result = vim.system({'jj', 'diff', '--name-only'}):wait()
        if not result.stdout then
            vim.notify('idk, jj diff failed', vim.log.levels.ERROR)
            return
        end
        local items = vim.split(result.stdout, "\n", { trimempty = true})
        vim.ui.select(items, {
            prompt = 'jj diff > ',
            preview_item = function()
                local log_result = vim.system({'jj', 'log'}):wait()
                local lines = log_result.stdout and
                    vim.split(log_result.stdout, "\n", {trimempty = true}) or
                    {'idk, jj log failed'}
                local buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                vim.bo[buf].bufhidden = 'wipe'
                return { buf = buf }
            end,
        }, function(item)
            if not item then
                return
            end
            vim.cmd('e ' .. vim.fn.fnameescape(item))
        end)
end

vim.keymap.set('n', '<leader>j', function() jj_diff_select() end)

vim.api.nvim_create_user_command('YankRelPath', function()
    local path = vim.fn.expand('%:.')
    vim.fn.setreg('+', path)
    vim.notify('Yanked: ' .. path .. ' to register +', vim.log.levels.INFO)
end, { desc = 'Yank relative path of current buffer to specified register' })
