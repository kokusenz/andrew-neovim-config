require'nvim-treesitter'.install({ 'lua', 'vim', 'c_sharp', 'javascript', 'typescript', 'python', 'html', 'css', 'scss', 'yaml', 'json', 'markdown', 'rust', 'cpp', 'bash' })

-- Enable treesitter highlighting for specific filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'vim', 'cs', 'javascript', 'typescript', 'python', 'html', 'css', 'scss', 'yaml', 'json', 'markdown', 'rust', 'cpp', 'sh' },
  callback = function()
    vim.treesitter.start()
  end,
})
