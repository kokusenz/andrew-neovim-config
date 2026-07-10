local fzy = require('fzy')
fzy.new_popup = require('floating').new_popup
local opts = require('config').options
local set_keymap = require('config').set_keymap

set_keymap(opts.keyconfig.files, true, function()
    local fd_cmd = table.concat({ Fdfunc, '--type', 'f', '--hidden', '--exclude', '.git', '--full-path'}, ' ')
    fzy.execute(fd_cmd, fzy.sinks.edit_file)
end)

-- todo set up prioritize_fzy_buffer and such using qwahl
