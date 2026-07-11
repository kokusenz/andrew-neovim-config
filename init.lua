vim.cmd.packadd('nvim.difftool')
vim.cmd.packadd('cfilter')
vim.pack.add({
    -- lsp related
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/GustavEikaas/easy-dotnet.nvim',
    'https://github.com/mfussenegger/nvim-dap',
    -- navigation related
    'https://codeberg.org/mfussenegger/nvim-fzy',
    -- git related
    'https://github.com/fabijanzulj/blame.nvim',
    'https://github.com/kokusenz/deltaview.nvim',
    -- colorschemes
    'https://github.com/sainnhe/gruvbox-material',
    'https://github.com/lifepillar/vim-solarized8',
    'https://github.com/catppuccin/nvim',
    'https://github.com/folke/tokyonight.nvim',
    'https://github.com/bluz71/vim-moonfly-colors',
    'https://github.com/rose-pine/neovim',
    -- dependencies
    'https://github.com/nvim-lua/plenary.nvim', -- for codecompanion and easy-dotnet
})

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'nvim-treesitter' and kind == 'update' then
            if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
            vim.cmd('TSUpdate')
        end
    end
})

require('secret')
require('preferences')
require('conveniences')
require('statusline')
require('searching')
require('jj')
