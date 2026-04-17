vim.diagnostic.config({ virtual_text = { current_line = true }, virtual_lines = false })

vim.keymap.set('n', '<leader>do', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true })

vim.keymap.set('n', '<leader>dd', function() vim.diagnostic.open_float() end, { silent = true, noremap = true })
