-- file search --
local all_files

if vim.fn.executable('fd') == 1 then--- Custom find function using fd for Vim's :find command
  all_files = vim.fn.systemlist('fd --type f --hidden --exclude .git')
elseif vim.fn.executable('fdfind') == 1 then
  all_files = vim.fn.systemlist('fdfind --type f --hidden --exclude .git')
else
  -- fallback to default behavior
  all_files = nil
end
--- Searches for files using fd and filters results by pattern match
--- @param cmdarg string The search pattern to filter files (case-insensitive)
--- @param cmdcomplete any Command completion argument (unused)
--- @return table Array of matching file paths
function UseFd(cmdarg, cmdcomplete)
    -- Filter files that match the cmdarg pattern
    local matches = vim.tbl_filter(function(file)
        return string.find(file:lower(), cmdarg:lower(), 1, true) ~= nil
    end, all_files)

    return matches
end

if all_files then
    vim.o.findfunc = 'v:lua.UseFd'
end

-- grep --
vim.opt.grepprg = 'rg --vimgrep --no-messages --smart-case --hidden'
vim.cmd([[cabbrev rg grep]])
