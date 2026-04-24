vim.cmd([[cabbrev dm DeltaMenu]])
vim.cmd([[cabbrev dv DeltaView]])
vim.cmd([[cabbrev d Delta]])
vim.keymap.set('n', '<leader>dd', function() vim.cmd([[Delta .]]) end, { silent = true, noremap = true })
