local fzy = require('fzy')
fzy.new_popup = require('floating').new_popup
local opts = require('config').options
local set_keymap = require('config').set_keymap

set_keymap(opts.keyconfig.files, true, function()
    local fd_cmd = table.concat({ Fdfunc, '--type', 'f', '--hidden', '--exclude', '.git', '--full-path'}, ' ')
    fzy.execute(fd_cmd, fzy.sinks.edit_file)
end)

set_keymap(opts.keyconfig.buffers, true, function()
  local bufs = vim.tbl_filter(
    function(b)
      return vim.fn.buflisted(b) == 1 and vim.bo[b].buftype ~= 'quickfix'
    end,
    vim.api.nvim_list_bufs()
  )
  local format_bufname = function(b)
    local fullname = vim.api.nvim_buf_get_name(b)
    local name
    if #fullname == 0 then
      name = '[No Name] (' .. vim.bo[b].buftype .. ')'
    else
      name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(b), ':.')
    end
    local modified = vim.bo[b].modified
    return modified and name .. ' [+]' or name
  end
  local select_opts = {
    prompt = 'Buffer: ',
    format_item = format_bufname
  }
  vim.ui.select(bufs, select_opts, function(b)
    if b then
      vim.api.nvim_set_current_buf(b)
    end
  end)
end)
