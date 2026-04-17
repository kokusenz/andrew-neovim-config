require('vanilla') -- basic vanilla nvim config, no plugins involved

-- to update specific plugin, or no args for all plugins
-- :lua vim.pack.update({ 'nvim-lspconfig' })
-- to delete
-- :lua vim.pack.del({ 'nvim-lspconfig' })
vim.pack.add({
    -- lsp related
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/GustavEikaas/easy-dotnet.nvim',
    'https://github.com/mfussenegger/nvim-dap',
    -- navigation related
    'https://github.com/ibhagwan/fzf-lua',
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/josephschmitt/pj.nvim',
    -- git related
    'https://github.com/fabijanzulj/blame.nvim',
    'https://github.com/kokusenz/deltaview.nvim',
    'https://github.com/kokusenz/delta.lua',
    -- ai related
    'https://github.com/olimorris/codecompanion.nvim',
    'https://github.com/ravitemer/codecompanion-history.nvim',
    'https://github.com/zbirenbaum/copilot.lua',
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

require('statusline')
require('colorscheme')
require('searching')
require('lsp')
require('make')
require('blametoggle')
require('fzf').setup_fzf_lua()
require('vimuiselect').setup()
require('oil').setup()
require('pj_config')
-- TODO implement autocompletion from youtube video
-- TODO switch to fzf lua vimuiselect, get rid of vimuiselect module
-- TODO add vim.cmd([[cabbrev dm DeltaMenu]])
-- TODO add vim.cmd([[cabbrev dv DeltaView]])
-- TODO deprecate specific keybinds one by one; use built in keybinds (:h gri)
-- -- although the quickfix binds I want; add one for :ccl
-- TODO get rid of easy dotnet command; for some reason, breaks things
-- TODO get rid of argpoon, replace with something mini?
-- TODO get change colorscheme to tokyonight
-- TODO just trim code in general, reduce lines in config
