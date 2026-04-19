local pj = require('pj')
pj.setup({
    picker = {
        type = 'fzf_lua'
    }
})
local open_pj = function()
    local cwd = vim.fn.getcwd()
    -- Find the nearest parent directory containing .git
    local monorepo_subdir = vim.fs.root(cwd, '.git')
    if monorepo_subdir then
        local handle = io.popen('pj --config ~/.config/pj/blank_config.yaml --marker project.json --marker *.csproj --path ' .. monorepo_subdir .. " --max-depth 8 2>&1")
        if handle then
            local result = handle:read("*a")
            handle:close()

            if result and result ~= "" then
                local projects = {}
                for line in result:gmatch("[^\r\n]+") do
                    -- Convert absolute path to relative path from monorepo root
                    local relative = line == monorepo_subdir and '/' or line:gsub('^' .. vim.pesc(monorepo_subdir) .. '/', '')
                    if line == cwd then
                        table.insert(projects, 1, relative)
                    else
                        table.insert(projects, relative)
                    end
                end
                require('fzf-lua').fzf_exec(projects, {
                    prompt = 'PJ> ',
                    previewer = false,
                    preview = 'tree -C -L 2 ' .. monorepo_subdir .. '/{}',
                    actions = {
                        ['default'] = function(selected)
                            if selected and selected[1] then
                                if selected[1] == monorepo_subdir then
                                    vim.cmd('cd ' .. monorepo_subdir)
                                else
                                    vim.cmd('cd ' .. monorepo_subdir .. '/' .. selected[1])
                                end
                            end
                        end
                    }
                })
            end
        end
    else
        pj.open()
    end
end

vim.keymap.set('n', '<leader>jp', open_pj)

local move_root_up = function()
    local cwd = vim.fn.getcwd()
    local parent = vim.fn.fnamemodify(cwd, ':h')
    if parent and parent ~= cwd then
        vim.cmd('cd ' .. parent)
        vim.notify('Relocated to: ' .. parent, vim.log.levels.INFO)
    else
        vim.notify('Already at root directory', vim.log.levels.WARN)
    end
end

vim.keymap.set('n', '<leader>j-', move_root_up)

vim.api.nvim_create_user_command('YankRelPath', function()
    local path = vim.fn.expand('%:.')
    vim.fn.setreg('+', path)
    vim.notify('Yanked: ' .. path .. ' to register +', vim.log.levels.INFO)
end, { desc = 'Yank relative path of current buffer to specified register' })
