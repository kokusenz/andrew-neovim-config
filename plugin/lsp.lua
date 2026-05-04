vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        vim.lsp.completion.enable(true, args.data.client_id, args.buf)
    end,
})

if require('config').autocomplete then
    vim.o.ac = true
    vim.o.complete = 'o'
    vim.o.completeopt = 'menu,menuone,popup,noinsert'
else
    vim.keymap.set('i', '<C-Space>', '<C-x><C-o>')
end

vim.lsp.enable({ 'tsgo' })
vim.lsp.enable({ 'somesass_ls' })
vim.lsp.enable('clangd')

local get_lua_ls_nvim_runtime = function()
    local config = require('config')
    local list = { vim.env.VIMRUNTIME }
    for _, path in ipairs(config.runtime_files) do
        list = vim.list_extend(list, vim.api.nvim_get_runtime_file(path, true))
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

vim.lsp.enable({ 'lua_ls' })

if require('config').lazy_dotnet then
    local setup_easy_dotnet = function()
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

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "cs",
        callback = function()
            if package.loaded['easy-dotnet'] then return end
            setup_easy_dotnet()
        end,
        desc = "Activate easy-dotnet lsp and nvim-dap for C# files"
    })

    vim.api.nvim_create_user_command('SD', setup_easy_dotnet, { desc = 'setup easy-dotnet and nvim-dap' })
else
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
    vim.keymap.set("n", "<leader>dP", dap.continue, { desc = "Start/continue debugging" })     -- P for proceed
    vim.keymap.set("n", "<leader>dO", dap.step_over, { desc = "Step over" })
    vim.keymap.set("n", "<leader>dI", dap.step_into, { desc = "Step into" })
    vim.keymap.set("n", "<leader>dE", dap.step_out, { desc = "Step out" })     -- E for exit
    vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to cursor" })
    vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle DAP REPL" })
    vim.keymap.set("n", "<leader>dj", dap.down, { desc = "Go down stack frame" })
    vim.keymap.set("n", "<leader>dk", dap.up, { desc = "Go up stack frame" })
end

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
vim.lsp.enable({ 'rust_analyzer' })

-- Stop LSP client for current buffer
--- Presents a vim.ui.select menu to choose which LSP client to stop if multiple are attached
local function stop_buffer_lsp()
    local clients = vim.lsp.get_clients({ bufnr = 0 })

    if #clients == 0 then
        vim.notify("No LSP clients attached to this buffer", vim.log.levels.INFO)
        return
    end

    vim.ui.select(clients, {
        prompt = "Stop LSP Client:",
        format_item = function(client)
            return string.format("[%d] %s", client.id, client.name)
        end,
    }, function(client)
        if client then
            vim.lsp.stop_client(client.id)
            vim.notify(
                string.format("Stopped LSP client: %s. save buffer to see this reflected. :e to reverse.", client.name),
                vim.log.levels.INFO)
        end
    end)
end

vim.keymap.set('n', '<leader>ls', stop_buffer_lsp,
    { noremap = true, silent = true, desc = 'Stop LSP for buffer' })
