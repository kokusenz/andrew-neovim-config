local M = {}

--- @class CustomOpts
local defaults = {
    --- @type boolean
    enable_unnamed_plus_paste = false,
    --- @type boolean
    enable_colon_find_fzy = false,
    --- @class CustomOptsColorscheme
    colorscheme = {
        --- @type 'catppuccin' | 'catppuccin-mocha' | 'catppuccin-latte' | 'catppuccin-frappe' | 'catppuccin-macchiato' | 'moonfly' | 'kanagawa-wave' | 'kanagawa-dragon' | 'kanagawa-lotus' | 'default'
        plugin_colorscheme_name = 'kanagawa-wave',
        transparent = true,
    },
    --- @type table
    keyconfig = {
        --- @type KeyConfig
        files = {
            modes = 'n',
            lhs = "<leader><leader>",
            custom = false
        },
        --- @type KeyConfig
        buffers = {
            modes = 'n',
            lhs = "<leader>b",
            custom = false
        },
        --- @type KeyConfig
        grep = {
            modes = 'n',
            lhs = "<leader>gr",
            custom = false
        },
        --- @type KeyConfig
        visual_grep = {
            modes = 'v',
            lhs = "<leader>8",
            custom = false
        },
        --- @type UserCommandConfig
        glance_delta = {
            name = 'GlanceDelta',
            opts = { range = true, desc = 'Glance at visually selected git diff text with syntax highlighting' },
            custom = false
        },
    },
    --- @alias Position 'center' | 'bottom' | 'top' | 'full'
    --- @type Position
    popup_position = 'bottom',
    --- possible files
    --- vim.api.nvim_get_runtime_file('lua/mini.test', true)
    --- though note vim.api.nvim_get_runtime_file significantly impacts load time
    --- { '/usr/share/hypr/stubs/' }
    --- @type string[][]
    runtime_files = { },
}

local options = vim.deepcopy(defaults)

--- sets a switchable keymap; if config leans default; then this won't trigger
--- this is just so that in code i don't have to write if config then keymap.set
--- @param config KeyConfig  Right-hand side |{rhs}| of the mapping, can be a Lua function.
--- @param custom boolean indicating this is custom behavior
--- @param rhs string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
local set_keymap = function(config, custom, rhs)
    if config.custom == custom then
        vim.keymap.set(config.modes, config.lhs, rhs, config.opts)
    end
end

--- sets a switchable user command; if config leans default; then this won't trigger
--- this is just so that in code i don't have to write if config then create_user_command
--- @param config UserCommandConfig  Right-hand side |{rhs}| of the mapping, can be a Lua function.
--- @param custom boolean indicating this is custom behavior
--- @param cmd string|fun(args: vim.api.keyset.create_user_command.command_args)
local create_user_command = function(config, custom, cmd)
    if config.custom == custom then
        vim.api.nvim_create_user_command(config.name, cmd, config.opts)
    end
end

---@param position? Position
local new_popup = function(position)
    local buf = vim.api.nvim_create_buf(false, true)
    if position ~= 'full' then
        vim.api.nvim_buf_set_keymap(buf, 't', '<ESC>', '<C-\\><C-c>', {})
    end
    vim.bo[buf].bufhidden = "wipe"
    local columns = vim.o.columns
    local lines = vim.o.lines
    local width = math.floor(columns * 0.8)
    local wide_width = math.floor(columns * 0.9)
    local height = math.floor(lines * 0.8)
    local half_height = math.floor(lines * 0.30)
    position = position or options.popup_position
    local opts = {
        relative = 'editor',
        style = 'minimal',
        col = math.floor((columns - (position == 'center' and width or wide_width)) * 0.5),
        row = position == 'bottom' and math.floor(lines * 0.63) or math.floor((lines - height) * 0.5),
        width = position == 'center' and width or wide_width,
        height = position == 'center' and height or half_height,
        border = "single" -- "rounded"
    }
    if position == 'full' then
        vim.api.nvim_win_set_buf(0, buf)
        return 0, buf
    end
    local win = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_set_option_value('winhighlight', "Normal:Normal,FloatBorder:FloatBorderTransparent", { win = win })
    return win, buf
end

-- idea; just use the terminal as my file browser
-- have a special init file that allows this to act as unnest, aliased where it calls nvim -u
-- some kind of autocmd stuff? but basically, if I use the nvim -u from the neovim terminal window, it actually sets the alternate buffer as the file (or terminal i guess) and exits the terminal

---@param cmd? string command to initialize the buffer; if omitted, starts an interactive shell
---@param position? Position
---@param cwd? string working directory for the terminal job
local execute_terminal_floating = function(cmd, position, cwd)
    if vim.api.nvim_get_mode().mode == "i" then
        vim.cmd('stopinsert')
    end
    local popup_win, buf = new_popup(position)
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
    local args = cmd and { vim.o.shell, vim.o.shellcmdflag, cmd } or { vim.o.shell }
    vim.fn.jobstart(args, { term = true, cwd = cwd })
end

--- @param dir string
--- @return { name: string, type: string }[]
local list_dir_entries = function(dir)
    local entries = {}
    local fd = vim.uv.fs_scandir(dir)
    if fd then
        while true do
            local name, typ = vim.uv.fs_scandir_next(fd)
            if not name then break end
            table.insert(entries, { name = name, type = typ })
        end
    end
    table.sort(entries, function(a, b) return a.name < b.name end)
    return entries
end

local browse_dir

--- @param dir string
browse_dir = function(dir)
    local items = { { name = '..', type = 'directory' } }
    vim.list_extend(items, list_dir_entries(dir))
    vim.ui.select(items, {
        prompt = dir,
        format_item = function(item)
            return item.type == 'directory' and (item.name .. '/') or item.name
        end,
    }, function(choice)
        if not choice then return end
        if choice.name == '..' then
            browse_dir(vim.fs.dirname(dir))
            return
        end
        local path = vim.fs.joinpath(dir, choice.name)
        if choice.type == 'directory' then
            browse_dir(path)
        else
            vim.cmd.edit(vim.fn.fnameescape(path))
        end
    end)
end

--- copy at lua/telescope/algos/fzy.lua in telescope.nvim
local Fzy = (function()
    local SCORE_GAP_LEADING = -0.005
    local SCORE_GAP_TRAILING = -0.005
    local SCORE_GAP_INNER = -0.01
    local SCORE_MATCH_CONSECUTIVE = 1.0
    local SCORE_MATCH_SLASH = 0.9
    local SCORE_MATCH_WORD = 0.8
    local SCORE_MATCH_CAPITAL = 0.7
    local SCORE_MATCH_DOT = 0.6
    local SCORE_MIN = -math.huge
    local SCORE_MAX = math.huge
    local MATCH_MAX_LENGTH = 1024
    local PATH_SEP = '/'

    local fzy = {}

    function fzy.has_match(needle, haystack)
        needle = string.lower(needle)
        haystack = string.lower(haystack)

        --- @type number|nil
        local j = 1
        for i = 1, string.len(needle) do
            j = string.find(haystack, needle:sub(i, i), j, true)
            if not j then
                return false
            else
                j = j + 1
            end
        end

        return true
    end

    local function is_lower(c) return c:match('%l') end
    local function is_upper(c) return c:match('%u') end

    local function precompute_bonus(haystack)
        local match_bonus = {}

        local last_char = PATH_SEP
        for i = 1, string.len(haystack) do
            local this_char = haystack:sub(i, i)
            if last_char == PATH_SEP then
                match_bonus[i] = SCORE_MATCH_SLASH
            elseif last_char == '-' or last_char == '_' or last_char == ' ' then
                match_bonus[i] = SCORE_MATCH_WORD
            elseif last_char == '.' then
                match_bonus[i] = SCORE_MATCH_DOT
            elseif is_lower(last_char) and is_upper(this_char) then
                match_bonus[i] = SCORE_MATCH_CAPITAL
            else
                match_bonus[i] = 0
            end

            last_char = this_char
        end

        return match_bonus
    end

    local function compute(needle, haystack, DD, MM)
        local match_bonus = precompute_bonus(haystack)
        local n = string.len(needle)
        local m = string.len(haystack)
        local lower_needle = string.lower(needle)
        local lower_haystack = string.lower(haystack)

        local haystack_chars = {}
        for i = 1, m do
            haystack_chars[i] = lower_haystack:sub(i, i)
        end

        for i = 1, n do
            DD[i] = {}
            MM[i] = {}

            local prev_score = SCORE_MIN
            local gap_score = i == n and SCORE_GAP_TRAILING or SCORE_GAP_INNER
            local needle_char = lower_needle:sub(i, i)

            for j = 1, m do
                if needle_char == haystack_chars[j] then
                    local score = SCORE_MIN
                    if i == 1 then
                        score = ((j - 1) * SCORE_GAP_LEADING) + match_bonus[j]
                    elseif j > 1 then
                        local a = MM[i - 1][j - 1] + match_bonus[j]
                        local b = DD[i - 1][j - 1] + SCORE_MATCH_CONSECUTIVE
                        score = math.max(a, b)
                    end
                    DD[i][j] = score
                    prev_score = math.max(score, prev_score + gap_score)
                    MM[i][j] = prev_score
                else
                    DD[i][j] = SCORE_MIN
                    prev_score = prev_score + gap_score
                    MM[i][j] = prev_score
                end
            end
        end
    end

    function fzy.score(needle, haystack)
        local n = string.len(needle)
        local m = string.len(haystack)

        if n == 0 or m == 0 or m > MATCH_MAX_LENGTH or n > MATCH_MAX_LENGTH then
            return SCORE_MIN
        elseif n == m then
            return SCORE_MAX
        else
            local DD, MM = {}, {}
            compute(needle, haystack, DD, MM)
            return MM[n][m]
        end
    end

    return fzy
end)()

local fdfunc = 'fdfind'

local cmp_keys = '<C-Space>'

--- @param opts? CustomOpts
M.setup = function(opts)
    options = vim.tbl_deep_extend("force", options, opts or {})

    vim.schedule(function()
        if vim.fn.executable('fd') == 1 then --- Custom find function using fd for Vim's :find command
            fdfunc = 'fd'
        elseif vim.fn.executable('fdfind') == 1 then
            fdfunc = 'fdfind'
        else
            vim.notify('fd not found on system. :find will not use fd', vim.log.levels.WARN)
            vim.opt.path:append { '**' }
            return
        end
    end)
end

M.preferences = function()
    vim.g.mapleader = " "
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
    vim.background = 'dark'

    vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
            vim.api.nvim_del_augroup_by_name('nvim.dir')
        end
    })

    -- set terminal as my directory browser
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'directory',
        callback = function(args)
            local dir = vim.api.nvim_buf_get_name(args.buf)
            vim.schedule(function()
                execute_terminal_floating(nil, 'full', dir)
            end)
        end,
    })
end

M.conveniences = function()
    if not options.enable_unnamed_plus_paste then vim.g.clipboard = 'osc52' end
    -- keybinds to use system keyboard
    vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { silent = true, noremap = true })
    if options.enable_unnamed_plus_paste then
        vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { silent = true, noremap = true })
    end

    -- pane resizing
    vim.keymap.set('n', '<C-w>0', '<C-w>=', { silent = true, noremap = true })
    vim.keymap.set('n', '<C-w>-', '12<C-w><', { silent = true, noremap = true })
    vim.keymap.set('n', '<C-w>=', '12<C-w>>', { silent = true, noremap = true })

    -- tab nav, mirrors gt/gT
    vim.keymap.set('n', '<C-w>n', vim.cmd.tabnext, { silent = true, noremap = true })
    vim.keymap.set('n', '<C-w>p', vim.cmd.tabprevious, { silent = true, noremap = true })
    vim.keymap.set('n', '<C-w><C-n>', vim.cmd.tabnext, { silent = true, noremap = true })
    vim.keymap.set('n', '<C-w><C-p>', vim.cmd.tabprevious, { silent = true, noremap = true })

    -- makes vertical nav a bit cleaner
    vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true, noremap = true })
    vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true, noremap = true })

    -- quickfix list nav bindings
    vim.keymap.set('n', '<Del>', vim.cmd.cclose)
    vim.keymap.set('n', '<leader>q', function() vim.cmd([[copen 6]]) end)

    -- make for cs files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "cs",
      callback = function()
        --vim.bo.makeprg = "dotnet build" -- this doesn't work lol
        vim.cmd("let dotnet_errors_only = v:true")
        vim.cmd("let dotnet_show_project_file = v:false")
        vim.cmd("compiler dotnet")
      end,
      desc = "Set dotnet compiler for C# files"
    })

    -- term
    vim.cmd([[cabbrev te \| term]])
    vim.keymap.set('n', '<leader>e', function()
        vim.cmd([[:sp | let $b=expand('%:p') | term]])
        vim.cmd([[startinsert!]])
    end)

    vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>', { silent = true, noremap = true })
    vim.keymap.set('t', '<C-w>n', '<C-\\><C-n>:tabnext<CR>', { silent = true, noremap = true })
    vim.keymap.set('t', '<C-w>p', '<C-\\><C-n>:tabprevious<CR>', { silent = true, noremap = true })
    vim.keymap.set('t', '<C-w><C-n>', '<C-\\><C-n>:tabnext<CR>', { silent = true, noremap = true })
    vim.keymap.set('t', '<C-w><C-p>', '<C-\\><C-n>:tabprevious<CR>', { silent = true, noremap = true })
    vim.keymap.set('t', '<C-q>', '<C-\\><C-n>', { silent = true, noremap = true })

    vim.keymap.set('n', '_', function()
        local path = vim.fn.expand('%:.')
        vim.fn.setreg('+', path)
        vim.notify('Yanked: ' .. path .. ' to register +', vim.log.levels.INFO)
    end, { desc = 'Yank relative path of current buffer to specified register' })

    vim.keymap.set('n', '-', function()
        -- open a picker with files inside the current directory, or sibling files if currently on a file
        -- selecting '..' goes up a directory, selecting a directory recurses into it, selecting a file opens it
        local dir = vim.fs.abspath(vim.fs.dirname(vim.fn.expand('%:.')))
        browse_dir(dir)
    end, {silent = true, noremap = true})

    vim.keymap.set('n', 'gj', function()
        vim.ui.input({prompt='  '}, function(input)
            if not input then
                return
            end
            local expanded = string.gsub(input, "%%", function(i) return vim.fn.expand(i..':p') end)
            execute_terminal_floating(expanded, 'center')
        end)
    end)

    create_user_command(options.keyconfig.glance_delta, false, function(cmd_opts)
        local lines = vim.api.nvim_buf_get_lines(0, cmd_opts.line1 - 1, cmd_opts.line2, false)
        local tmpfile = vim.fn.tempname()
        vim.fn.writefile(lines, tmpfile)
        local escaped = vim.fn.shellescape(tmpfile)
        execute_terminal_floating('cat ' .. escaped .. ' | delta; rm ' .. escaped, 'center')
    end)
end

M.searching = function()
    -- grep --
    local grepprg = { 'rg', '--vimgrep', '--no-messages', '--smart-case', '--hidden', '-g', '!.git/**' }
    vim.opt.grepprg = table.concat(grepprg, " ")
    vim.cmd([[cabbrev gr silent! grep!]])
    -- use grep as the ex command if you are looking to use regex, otherwise here are wrappers that search fixed strings

    local grep_to_qflist = function(search)
        local command = {}
        for _, cmd in ipairs(grepprg) do
            table.insert(command, cmd)
        end
        table.insert(command, '--fixed-strings')
        table.insert(command, search)
        local result = vim.system(command, { text = true }):wait()
        if result.stdout ~= '' then
            local lines = vim.split(result.stdout, "\n", { trimempty = true })
            vim.fn.setqflist({}, ' ', { lines = lines, efm = vim.o.grepformat, title = table.concat(command, " ") })
        else
            vim.fn.setqflist({}, ' ', { lines = {}, efm = vim.o.grepformat, title = table.concat(command, " ") })
        end
        vim.cmd('copen 6')
        local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
        if qf_winid ~= 0 then
            vim.api.nvim_win_call(qf_winid, function()
                vim.fn.clearmatches()
                vim.api.nvim_set_hl(0, 'QfMatch', { bold = true, fg = '#9df0a2' })
                vim.fn.matchadd('QfMatch', search)
            end)
        end
    end

    set_keymap(options.keyconfig.grep, false, function()
        vim.ui.input({ prompt = " grep 󰨀 " }, function(input)
            if input ~= nil then grep_to_qflist(input) end
        end)
    end)

    set_keymap(options.keyconfig.visual_grep, false, function()
        local input = table.concat(vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.')), "\n")
        grep_to_qflist(input)
    end)

    function UseFd(cmdarg, _)
        local arg = tostring(cmdarg)
        local param = vim.fn.getcwd() .. ".*"
        param = not options.enable_colon_find_fzy and param .. arg or param
        local fdout = vim.system({
            fdfunc,
            '--type',
            'f',
            '--hidden',
            '--exclude',
            '.git',
            '--full-path',
            param}
        ):wait()
        local all_files = vim.split(fdout.stdout, "\n", { trimempty = true })
        return not options.enable_colon_find_fzy and
            all_files or
            vim.tbl_filter(function(f) return Fzy.has_match(arg, f) end, all_files)
    end

    set_keymap(options.keyconfig.files, false, ':find ')
    vim.o.findfunc = 'v:lua.UseFd'

    -- buffer --
    set_keymap(options.keyconfig.buffers, false, function()
        vim.cmd('ls')
        vim.fn.feedkeys(':b ', 'n')
    end)
end

M.jujutsu = function()
    local jj_diff_select = function()
        local result = vim.system({'jj', 'diff', '--name-only'}):wait()
        if not result.stdout then
            vim.notify('idk, jj diff failed', vim.log.levels.ERROR)
            return
        end
        local items = vim.split(result.stdout, "\n", { trimempty = true})
        vim.ui.select(items, {
            prompt = 'jj diff > ',
            format_item = function(item)
                return item
            end,
        }, function(item)
            if not item then
                return
            end
            vim.cmd('e ' .. vim.fn.fnameescape(item))
        end)
    end

    vim.keymap.set('n', '<leader>j', function() jj_diff_select() end)
end

M.nvim_treesitter = function()
    vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

    vim.api.nvim_create_autocmd('PackChanged', {
        callback = function(ev)
            local name, kind = ev.data.spec.name, ev.data.kind
            if name == 'nvim-treesitter' and kind == 'update' then
                if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
                vim.cmd('TSUpdate')
            end
        end
    })

    require('nvim-treesitter').install({
        'lua',
        'vim',
        'c_sharp',
        'javascript',
        'typescript',
        'python',
        'html',
        'css',
        'scss',
        'yaml',
        'json',
        'markdown',
        'rust',
        'cpp',
        'bash',
        'zig'
    })

    -- Enable treesitter highlighting for specific filetypes
    vim.api.nvim_create_autocmd('FileType', {
        pattern = {
            'lua',
            'vim',
            'cs',
            'javascript',
            'typescript',
            'python',
            'html',
            'css',
            'scss',
            'yaml',
            'json',
            'markdown',
            'rust',
            'cpp',
            'sh',
            'zig'
        },
        callback = function()
            local buf = vim.api.nvim_get_current_buf()
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(buf) then
                    vim.treesitter.start(buf)
                end
            end)
        end,
    })
end

M.cfilter = function()
    vim.cmd.packadd('cfilter')
end

M.lsp_config = function()
    vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })

    local get_lua_ls_nvim_runtime = function()
        local list = { vim.env.VIMRUNTIME }
        for _, path in ipairs(options.runtime_files) do
            list = vim.list_extend(list, path)
        end
        return list
    end

    vim.lsp.config('lua_ls', {
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                    path ~= vim.fn.stdpath('config')
                    and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most
                    -- likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Tell the language server how to find Lua modules same way as Neovim
                    -- (see `:h lua-module-load`)
                    path = {
                        'lua/?.lua',
                        'lua/?/init.lua',
                    },
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = get_lua_ls_nvim_runtime()
                    -- Or pull in all of 'runtimepath'.
                    -- NOTE: this is a lot slower and will cause issues when working on
                    -- your own configuration.
                    -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                    -- library = vim.api.nvim_get_runtime_file('', true),
                },
            })
        end,
        settings = {
            Lua = {},
        },
    })

    vim.lsp.config['rust_analyzer'] = {
        settings = {
            ["rust-analyzer"] = {
                imports = {
                    granularity = {
                        group = "module",
                    },
                    prefix = "self",
                },
                cargo = {
                    buildScripts = {
                        enable = true,
                    },
                },
                procMacro = {
                    enable = true
                },
            }
        }
    }

    local lsps = { 'tsgo', 'lua_ls', 'zls', 'clangd', 'rust_analyzer' }
    -- filetypes derived from vim.lsp.config[lsp_name].filetypes
    -- hard coding neccessary because checking filetypes programmatically expensive and slow
    local lsp_filetypes = {
        tsgo = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        lua_ls = { 'lua' },
        zls = { 'zig', 'zir' },
        c = { 'c', 'c.doxygen', 'cpp', 'cpp.doxygen', 'objc', 'objcpp', 'cuda' },
        rust_analyzer = { 'rust' },
    }

    for _, name in ipairs(lsps) do
        local fts = lsp_filetypes[name]
        vim.api.nvim_create_autocmd('FileType', {
            pattern = fts,
            once = true,
            callback = function()
                vim.lsp.enable(name)
            end,
        })
    end

    vim.api.nvim_create_autocmd('FileType', {
        pattern = {'cs'},
        once = true,
        callback = function()
            vim.pack.add({ 'https://github.com/seblyng/roslyn.nvim' })
            require('roslyn').setup({ broad_search = true })
        end,
    })

    local mapping = vim.fn.maparg(cmp_keys, "i")
    if mapping == "" then
        vim.keymap.set('i', cmp_keys, '<C-x><C-o>')
    end
end

--- fzy-based `filtersort` for `mini.completion`'s `lsp_completion.process_items`.
--- Filters candidates to those fzy-matching `base`, then sorts by fzy score
--- (descending). When `base` is empty, candidates are left in LSP-provided order.
--- @param items table[]
--- @param base string
local fzy_filtersort = function(items, base)
    if base == '' then return vim.deepcopy(items) end

    local scored = {}
    for _, item in ipairs(items) do
        local text = item.filterText or item.label
        if Fzy.has_match(base, text) then
            table.insert(scored, { item = item, score = Fzy.score(base, text) })
        end
    end
    table.sort(scored, function(a, b) return a.score > b.score end)

    local result = {}
    for _, s in ipairs(scored) do table.insert(result, s.item) end
    return result
end

M.completion = function()
    vim.pack.add({ 'https://github.com/nvim-mini/mini.completion' })

    vim.keymap.del('i', cmp_keys)
    local mini_completion = require('mini.completion')
    vim.o.completeopt = 'menu,menuone,noselect,fuzzy'

    --- @param items table[]
    --- @param base string
    local process_items = function(items, base)
        local result = mini_completion.default_process_items(items, base, { filtersort = fzy_filtersort })
        if #result == 1 then
            vim.schedule(function()
                local keys = vim.api.nvim_replace_termcodes('<C-n><C-y>', true, false, true)
                vim.api.nvim_feedkeys(keys, 'n', false)
            end)
        end
        return result
    end

    mini_completion.setup({
        delay = { completion = 10^7, info = 10^7, signature = 10^7 },
        lsp_completion = {
            process_items = process_items,
        },
        mappings = {
            force_twostep = cmp_keys,
        },
    })
end

M.easy_dotnet = function()
    vim.pack.add({
        'https://github.com/nvim-lua/plenary.nvim',
        'https://github.com/GustavEikaas/easy-dotnet.nvim',
        'https://github.com/mfussenegger/nvim-dap',
    })

    require('easy-dotnet').setup({
        lsp = {
            auto_refresh_codelens = false
        },
        test_runner = {
            viewmode = 'vsplit'
        },
    })

    local dap = require('dap')

    vim.keymap.set("n", "q", function()
        dap.terminate()
        dap.clear_breakpoints()
    end, { desc = "Terminate and clear breakpoints" })

    vim.keymap.set("n", "<leader>dB", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    vim.keymap.set("n", "<leader>dP", dap.continue, { desc = "Start/continue debugging" }) -- P for proceed
    vim.keymap.set("n", "<leader>dO", dap.step_over, { desc = "Step over" })
    vim.keymap.set("n", "<leader>dI", dap.step_into, { desc = "Step into" })
    vim.keymap.set("n", "<leader>dE", dap.step_out, { desc = "Step out" }) -- E for exit
    vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to cursor" })
    vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle DAP REPL" })
    vim.keymap.set("n", "<leader>dj", dap.down, { desc = "Go down stack frame" })
    vim.keymap.set("n", "<leader>dk", dap.up, { desc = "Go up stack frame" })
end

M.fzy = function()
    vim.pack.add({ 'https://codeberg.org/mfussenegger/nvim-fzy' })

    local fzy = require('fzy')
    fzy.new_popup = new_popup

    set_keymap(options.keyconfig.files, true, function()
        local fd_cmd = table.concat({ fdfunc, '--type', 'f', '--hidden', '--exclude', '.git', '--full-path' }, ' ')
        fzy.execute(fd_cmd, fzy.sinks.edit_file)
    end)

    set_keymap(options.keyconfig.buffers, true, function()
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
end

M.deltaview = function()
    vim.pack.add({ 'https://github.com/kokusenz/deltaview.nvim' })
    vim.cmd([[cabbrev dm DeltaMenu]])
    vim.cmd([[cabbrev dv DeltaView]])
    vim.cmd([[cabbrev da Delta . 3]])

    create_user_command(options.keyconfig.glance_delta, true, function(cmd_opts)
        local lines = table.concat(vim.api.nvim_buf_get_lines(0, cmd_opts.line1 - 1, cmd_opts.line2, false), '\n')
        local win, _ = new_popup('center')
        local delta = require('delta')
        local bufnr = delta.patch_diff(lines, true)
        if bufnr == nil then return end
        vim.api.nvim_win_set_buf(win, bufnr)
        vim.schedule(function() delta.highlight_delta_artifacts(bufnr) end)
        vim.schedule(function() delta.syntax_highlight_diff_set(bufnr) end)
        vim.schedule(function() delta.diff_highlight_diff(bufnr) end)
    end)
end

M.guh = function()
    vim.pack.add({ 'https://github.com/justinmk/guh.nvim' })
end

M.colorscheme = function()
    vim.pack.add({
        'https://github.com/catppuccin/nvim',
        'https://github.com/bluz71/vim-moonfly-colors',
        'https://github.com/rebelot/kanagawa.nvim',
    })

    local ocs = options.colorscheme

    vim.api.nvim_create_autocmd('ColorSchemePre', {
        pattern = 'catppuccin*',
        once = true,
        callback = function()
            require("catppuccin").setup({
                transparent_background = ocs.transparent,
                flavour = 'mocha'
            })
        end,
    })

    vim.api.nvim_create_autocmd('ColorSchemePre', {
        pattern = 'kanagawa*',
        once = true,
        callback = function()
            require("kanagawa").setup({
                transparent = ocs.transparent,
                colors = { theme = { all = { ui = { bg_gutter = "none" } } } }
            })
        end,
    })

    vim.g.moonflyTransparent = ocs.transparent
    vim.g.moonflyVirtualTextColor = true
    vim.cmd('silent! colorscheme ' .. ocs.plugin_colorscheme_name)
end

M.statusline = function()
    local cmp = {} -- statusline components

    --- Global function to retrieve and call statusline component functions
    --- Used in statusline format strings via %{%v:lua._statusline_component("name")%}
    --- @param name string The component name to retrieve from the cmp table
    --- @return string The result of calling the component function
    function _G._statusline_component(name)
        return cmp[name]()
    end

    local hi_pattern = '%%#%s#%s%%*'

    --- Display diagnostic status for the current buffer
    --- Shows error count, warning count, or OK indicator with appropriate highlighting
    --- @return string Formatted diagnostic status string with highlight groups
    function cmp.diagnostic_status()
        local mode = vim.api.nvim_get_mode().mode

        if mode == 'c' then
            return hi_pattern:format('', '   ')
        end
        if mode == 't' then
            return hi_pattern:format('', '   ')
        end

        local levels = vim.diagnostic.severity
        local errors = #vim.diagnostic.get(0, {severity = levels.ERROR})
        if errors > 0 then
            return hi_pattern:format('DiagnosticError', errors .. '  ')
        end

        local warnings = #vim.diagnostic.get(0, {severity = levels.WARN})
        if warnings > 0 then
            return hi_pattern:format('DiagnosticWarn', warnings .. '  ')
        end

        return hi_pattern:format('DiagnosticOk', '   ')
    end

    --- Display current line and column position
    --- @return string Formatted position string with Search highlight group
    function cmp.line_position()
        return hi_pattern:format('', '%3l:%-3c')
    end

    -- do %t for "tail end of file" (eg. file name), but %f if file path matters (eg. duplicate file names because bad repositories lol)
    local statusline = {
        '%t',
        '%r',
        '%m',
        '%=',
        '%{%v:lua._statusline_component("line_position")%}',
        '%{%v:lua._statusline_component("diagnostic_status")%} '
    }

    vim.o.statusline = table.concat(statusline, '')
end

M.tabline = function()
    local function emphasize_current_tab()
        local hl = vim.api.nvim_get_hl(0, { name = 'TabLineSel', link = false })
        hl.standout = true
        --- @diagnostic disable: param-type-mismatch
        vim.api.nvim_set_hl(0, 'TabLineSel', hl)
    end

    emphasize_current_tab()
    vim.api.nvim_create_autocmd('ColorScheme', { callback = emphasize_current_tab })
end

return M

--- If there is not a default, this, i guess setting default to false just disables it
--- @class KeyConfig
--- @field modes string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
--- @field lhs string|string[]  Left-hand side |{lhs}| of the mapping, or a list thereof.
--- @field opts? vim.keymap.set.Opts
--- @field custom boolean if false, then use default behavior

--- If there is not a default, this, i guess setting default to false just disables it
--- @class UserCommandConfig
--- @field name string
--- @field opts? vim.api.keyset.user_command
--- @field custom boolean if false, then use default behavior
