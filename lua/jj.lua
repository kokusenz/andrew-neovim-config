local quick_command_list = {
    --- @class QCItem
    log = {
        formatted = 'log',
        on_select = function() require('floating').execute_terminal_floating('jj log') end
    },
    --- @type QCItem
    st = {
        formatted = 'status',
        on_select = function() require('floating').execute_terminal_floating('jj st') end
    },
    --- @type QCItem
    diff = {
        formatted = 'edit',
        on_select = function() require('floating').execute_terminal_floating('jj diff', 'center') end
    },
    describe = {
        formatted = 'describe',
        on_select = function() require('floating').execute_terminal_floating('jj describe') end
    },
}

local jj_quick_command = function()
    local items = {}
    for k in pairs(quick_command_list) do
        table.insert(items, k)
    end
    vim.ui.select(items, {
        prompt = 'jj quick command > ',
        format_item = function(item)
            return quick_command_list[item].formatted
        end,
    }, function(item)
        if not item then
            return
        end
        quick_command_list[item].on_select()
    end)
end

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

-- vim.keymap.set('n', '<leader>w', function()
--     require('floating').execute_terminal_floating('jj diff -- ' .. vim.fn.expand('%:p'), 'center')
-- end)
vim.keymap.set('n', 'gj', function() jj_quick_command() end)
vim.keymap.set('n', '<leader>j', function() jj_diff_select() end)
