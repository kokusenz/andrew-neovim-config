vim.wo.relativenumber = true
vim.opt.tabstop       = 4  -- literal <Tab> == 4 spaces when files are read
vim.opt.shiftwidth    = 4  -- >> << == 4 spaces
vim.opt.softtabstop   = 4  -- <Tab> while typing feels like 4 spaces
vim.opt.expandtab     = true -- convert <Tab> presses to spaces (optional)
vim.opt.background    = 'dark'
vim.opt.termguicolors = true
vim.opt.ignorecase    = true
vim.opt.smartcase     = true
vim.diagnostic.config({ virtual_text = { current_line = true }, virtual_lines = false })
-- default:
-- vim.opt.guicursor='n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor'
vim.opt.guicursor='n-v-c-sm:block,i-ci-ve:block-blinkwait0-blinkon100-blinkoff100,r-cr-o:block-blinkwait0-blinkon100-blinkoff100,t:block-blinkon500-blinkoff500-TermCursor'

local opts = require('config').options
vim.cmd('silent! colorscheme ' .. opts.colorscheme.default_colorscheme_name)
if opts.colorscheme.transparent then
    vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
            vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
        end,
        desc = 'Reinitialize Delta highlight groups after colorscheme change'
    })
end
