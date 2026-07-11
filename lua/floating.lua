local M = {}

---@param position? Position
M.new_popup = function(position)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_keymap(buf, 't', '<ESC>', '<C-\\><C-c>', {})
    vim.bo[buf].bufhidden = "wipe"
    local columns = vim.o.columns
    local lines = vim.o.lines
    local width = math.floor(columns * 0.8)
    local height = math.floor(lines * 0.8)
    local half_height = math.floor(lines * 0.30)
    position = position or require('config').options.popup_position
    local opts = {
        relative = 'editor',
        style = 'minimal',
        col = math.floor((columns - width) * 0.5),
        row = position == 'bottom' and math.floor(lines * 0.63) or math.floor((lines - height) * 0.5),
        width = width,
        height = position == 'center' and height or half_height,
        border = "single" -- "rounded"
    }
    local win = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_set_option_value('winhighlight', "Normal:Normal,FloatBorder:FloatBorderTransparent", { win = win })
    return win, buf
end

---@param cmd string command to initialize the buffer
---@param position? Position
M.execute_terminal_floating = function(cmd, position)
    if vim.api.nvim_get_mode().mode == "i" then
        vim.cmd('stopinsert')
    end
    local popup_win, buf = M.new_popup(position)
    vim.api.nvim_create_autocmd("WinLeave", {
        callback = function()
            local w = vim.api.nvim_get_current_win()
            if w == popup_win then
                vim.api.nvim_buf_delete(buf, { force = true })
                return true
            end
        end,
    })
    vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
        buffer = buf,
        command = 'startinsert!',
        once = true,
    })
    local args = { vim.o.shell, vim.o.shellcmdflag, cmd }
    vim.fn.jobstart(args, { term = true })
end

return M
