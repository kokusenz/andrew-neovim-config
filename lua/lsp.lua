local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
  }
})

local caps = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.enable({'tsgo'})

vim.lsp.enable({'somesass_ls'})

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
        library = vim.list_extend(
            { vim.env.VIMRUNTIME },
            vim.api.nvim_get_runtime_file('lua/delta', true)
        )
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

vim.lsp.enable({'lua_ls'})

--vim.lsp.enable({'angularls'})

vim.lsp.enable('clangd')

vim.lsp.config['rust_analyzer'] = {
  capabilities = caps,
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
vim.lsp.enable({'rust_analyzer'})

vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition,
  { noremap = true, silent = true, desc = 'LSP definition' })
vim.keymap.set('n', '<leader>hv', vim.lsp.buf.hover,
  { noremap = true, silent = true, desc = 'LSP hover' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,
  { noremap = true, silent = true, desc = 'LSP code action' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,
  { noremap = true, silent = true, desc = 'LSP rename' })
vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format,
  { noremap = true, silent = true, desc = 'LSP format' })

require('easy-dotnet').setup()

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
      vim.notify(string.format("Stopped LSP client: %s. save buffer to see this reflected. :e to reverse.", client.name), vim.log.levels.INFO)
    end
  end)
end

vim.keymap.set('n', '<leader>ls', stop_buffer_lsp,
  { noremap = true, silent = true, desc = 'Stop LSP for buffer' })
