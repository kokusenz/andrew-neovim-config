local jj_diff_select = function()
    local result = vim.system({'jj', 'diff', '--name-only'}):wait()
    if not result.stdout then
        vim.notify('idk, jj diff failed', vim.log.levels.ERROR)
        return
    end
    local items = vim.split(result.stdout, "\n", { trimempty = true})
    vim.ui.select(items, {
        prompt = 'jj diff > ',
        format_item = function(item)
            return item
        end,
    }, function(item)
        if not item then
            return
        end
        vim.cmd('e ' .. vim.fn.fnameescape(item))
    end)
end

vim.keymap.set('n', 'gj', function() require('floating').execute_terminal_floating('jj log') end)
vim.keymap.set('n', '<leader>j', function() jj_diff_select() end)
