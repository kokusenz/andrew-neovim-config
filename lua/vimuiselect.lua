local M = {}
--- Setup function to override vim.ui.select and configure keymaps
--- Sets up ',,' keymap to jump to ui_select window if one is open
function M.setup()
    require('deltaview').register_ui_select()
end

return M
