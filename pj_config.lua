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
        local handle = io.popen('pj --config ~/.config/pj/blank_config.yaml --marker project.json --marker Program.cs --marker Dockerfile --path ' .. monorepo_subdir .. " --max-depth 8 2>&1")
        if handle then
            local result = handle:read("*a")
            handle:close()

            if result and result ~= "" then
                local projects = {}
                for line in result:gmatch("[^\r\n]+") do
                    -- Convert absolute path to relative path from monorepo root
                    if line == monorepo_subdir then
                        table.insert(projects, '/')
                    elseif line == cwd then
                        local relative = line:gsub('^' .. vim.pesc(monorepo_subdir) .. '/', '')
                        table.insert(projects, 1, relative)
                    else
                        local relative = line:gsub('^' .. vim.pesc(monorepo_subdir) .. '/', '')
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
