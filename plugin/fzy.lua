local fzy = require('fzy')
fzy.new_popup = require('floating').new_popup
local opts = require('config').options

if opts.fzy.prioritize_fzy_files then
    vim.keymap.set('n', '<leader><leader>', function()
        local fd_cmd = table.concat({ Fdfunc, '--type', 'f', '--hidden', '--exclude', '.git', '--full-path'}, ' ')
        fzy.execute(fd_cmd, fzy.sinks.edit_file)
    end)
end

-- todo set up prioritize_fzy_buffer and such using qwahl
