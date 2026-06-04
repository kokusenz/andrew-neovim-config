require'nvim-treesitter'.install({ 'lua', 'vim', 'c_sharp', 'javascript', 'typescript', 'python', 'html', 'css', 'scss', 'yaml', 'json', 'markdown', 'rust', 'cpp', 'bash', 'zig' })

-- Enable treesitter highlighting for specific filetypes
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'lua', 'vim', 'cs', 'javascript', 'typescript', 'python', 'html', 'css', 'scss', 'yaml', 'json', 'markdown', 'rust', 'cpp', 'sh', 'zig' },
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(buf) then
                vim.treesitter.start(buf)
            end
        end)
    end,
})
