require('blame').setup();
vim.keymap.set('n', "<leader>bt", function() vim.cmd("BlameToggle") end);
