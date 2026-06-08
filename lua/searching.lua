-- grep --
local grepprg = {'rg', '--vimgrep', '--no-messages', '--smart-case', '--hidden'}
vim.opt.grepprg = table.concat(grepprg, " ")
vim.cmd([[cabbrev gr silent! grep!]])
vim.cmd([[cabbrev co \| copen]])
-- use grep as the ex command if you are looking to use regex, otherwise here are wrappers that search fixed strings

local grep_to_qflist = function(search)
    local command = {}
    for _, cmd in ipairs(grepprg) do
        table.insert(command, cmd)
    end
    table.insert(command, '--fixed-strings')
    table.insert(command, search)
    local result = vim.system(command, { text = true }):wait()
    if result.stdout ~= '' then
        local lines = vim.split(result.stdout, "\n", { trimempty = true })
        vim.fn.setqflist({}, ' ', { lines = lines, efm = vim.o.grepformat, title = table.concat(command, " ") })
    else
        vim.fn.setqflist({}, ' ', { lines = {}, efm = vim.o.grepformat, title = table.concat(command, " ") })
    end
    vim.cmd('copen')
    local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
    if qf_winid ~= 0 then
        vim.api.nvim_win_call(qf_winid, function()
            vim.fn.clearmatches()
            vim.api.nvim_set_hl(0, 'QfMatch', { bold = true, fg = '#9df0a2' })
            vim.fn.matchadd('QfMatch', search)
        end)
    end
end

local config = require('config')
if not config.fzf_lua.prioritize_fzf_lua_grep then
    -- fixed string search, not regex
    vim.keymap.set('n', '<leader>gr', function()
        vim.ui.input({prompt = " grep 󰨀 "}, function(input)
            if input ~= nil then grep_to_qflist(input) end
        end)
    end)
end

if not config.fzf_lua.prioritize_fzf_lua_grep then
    -- does not work well with visual line selection.
    vim.keymap.set('v', '<leader>8', function()
        local input = table.concat(vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.')), "\n")
        grep_to_qflist(input)
    end)
end

-- file search --
local fdfunc = 'fdfind'

vim.schedule(function()
    if vim.fn.executable('fd') == 1 then--- Custom find function using fd for Vim's :find command
      fdfunc = 'fd'
    elseif vim.fn.executable('fdfind') == 1 then
      fdfunc = 'fdfind'
    else
        vim.notify('fd not found on system. :find will not use fd', vim.log.levels.WARN)
        vim.opt.path:append { '**' }
        return
    end
end)

function UseFd(cmdarg, _)
    local param = vim.fn.getcwd() .. '.*' .. tostring(cmdarg)
    local fdout = vim.system(
        { fdfunc, '--type', 'f', '--hidden', '--exclude', '.git', '--full-path', param}
    ):wait()
    local matches = vim.split(fdout.stdout, "\n", { trimempty = true })
    return matches
end

if not config.fzf_lua.prioritize_fzf_lua_files then
    -- intentionally overwritten by fzf-lua module, if loaded.
    vim.keymap.set('n', '<leader><leader>', ':find ')
end
vim.o.findfunc = 'v:lua.UseFd'

-- buffer --
if not config.fzf_lua.prioritize_fzf_lua_buffers then
    -- use this with typing the name and tabcomplete or typing the number
    vim.keymap.set('n', '<leader>b', function()
        vim.cmd('ls')
        vim.fn.feedkeys(':b ', 'n')
    end)
end
