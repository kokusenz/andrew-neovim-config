-- grep --
vim.opt.grepprg = 'rg --vimgrep --no-messages --smart-case --hidden'
vim.cmd([[cabbrev gr silent! grep!]])
vim.cmd([[cabbrev co \| copen]])
-- intentionally overwritten by fzf-lua module, if loaded.
vim.keymap.set('n', '<leader>gr', function()
    vim.ui.input({prompt = "Grep For: "}, function(input)
        vim.cmd("silent! grep! " .. input .. " | copen")
    end)
end)

-- file search --
local fdfunc

if vim.fn.executable('fd') == 1 then--- Custom find function using fd for Vim's :find command
  fdfunc = 'fd'
elseif vim.fn.executable('fdfind') == 1 then
  fdfunc = 'fdfind'
else
    vim.notify('fd not found on system. :find will not use fd', vim.log.levels.WARN)
    vim.opt.path:append { '**' }
    return
end

function UseFd(cmdarg, _)
    local param = vim.fn.getcwd() .. '.*' .. tostring(cmdarg)
    local fdout = vim.system(
        { fdfunc, '--type', 'f', '--hidden', '--exclude', '.git', '--full-path', param}
    ):wait()
    local matches = vim.split(fdout.stdout, "\n", { trimempty = true })
    return matches
end

-- intentionally overwritten by fzf-lua module, if loaded.
vim.keymap.set('n', '<leader><leader>', ':find ')
vim.o.findfunc = 'v:lua.UseFd'
