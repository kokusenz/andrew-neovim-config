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
        table.insert(items, 'jj_st')
        table.insert(items, 'jj_log')
        table.insert(items, 'jj_diff')
        vim.ui.select(items, {
            prompt = 'jj diff > ',
            format_item = function(item)
                if item == 'jj_log' then
                    return 'jj log '
                end
                if item == 'jj_st' then
                    return 'jj status '
                end
                if item == 'jj_diff' then
                    return 'jj diff '
                end
                return item
            end,
            preview_item = function(item)
                local buf = vim.api.nvim_create_buf(false, true)
                vim.schedule(function()
                    vim.api.nvim_buf_call(buf, function()
                        if item == 'jj_log' then
                            vim.fn.jobstart({ 'jj', 'log' }, { term = true })
                            return
                        end
                        if item == 'jj_status' then
                            vim.fn.jobstart({ 'jj', 'st' }, { term = true })
                            return
                        end
                        if item == 'jj_diff' then
                            vim.fn.jobstart({ 'jj', 'diff', '--no-pager' }, { term = true })
                            return
                        end
                        vim.fn.jobstart({ 'jj', 'diff', '--no-pager', '--', item }, { term = true })
                    end)
                end)
                vim.bo[buf].bufhidden = 'wipe'
                return { buf = buf }
            end,
        }, function(item)
            if not item then
                return
            end
            if item == 'jj_log' then
                require('floating').execute_terminal_floating('jj log')
                return
            end
            if item == 'jj_st' then
                require('floating').execute_terminal_floating('jj st')
                return
            end
            if item == 'jj_diff' then
                require('floating').execute_terminal_floating('jj diff')
                return
            end
            vim.cmd('e ' .. vim.fn.fnameescape(item))
        end)
end

vim.keymap.set('n', '<leader>j', function() jj_diff_select() end)

