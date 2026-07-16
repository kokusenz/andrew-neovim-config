local function emphasize_current_tab()
    local hl = vim.api.nvim_get_hl(0, { name = 'TabLineSel', link = false })
    hl.standout = true
    vim.api.nvim_set_hl(0, 'TabLineSel', hl)
end

emphasize_current_tab()
vim.api.nvim_create_autocmd('ColorScheme', { callback = emphasize_current_tab })
