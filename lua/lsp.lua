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
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library',
          -- '${3rd}/busted/library',
        },
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

-- monkey-patch to fix lua_ls double go_definition issue https://github.com/LuaLS/lua-language-server/issues/2451
local locations_to_items = vim.lsp.util.locations_to_items
vim.lsp.util.locations_to_items = function (locations, offset_encoding)
  local lines = {}
  local loc_i = 1
  for _, loc in ipairs(vim.deepcopy(locations)) do
    local uri = loc.uri or loc.targetUri
    local range = loc.range or loc.targetSelectionRange
    if lines[uri .. range.start.line] then -- already have a location on this line
      table.remove(locations, loc_i) -- remove from the original list
    else
      loc_i = loc_i + 1
    end
    lines[uri .. range.start.line] = true
  end

  return locations_to_items(locations, offset_encoding)
end
-- end monkey patch

--vim.lsp.enable({'angularls'})

vim.lsp.enable('clangd')

local omnisharp_bin = "/usr/bin/omnisharp"
vim.lsp.config['omnisharp'] = {
  cmd = {
    omnisharp_bin,
    "--languageserver",
    "--hostPID", tostring(vim.fn.getpid()),
    "-z", -- use zero‑based line/column (VS Code behaviour)
    "--encoding", "utf-8",
    "DotNet:enablePackageRestore=false",
  },
  capabilities = caps, -- the `caps` table you already created
  filetypes = { "cs" },
  settings = {         -- (optional) tweak server behaviour
    FormattingOptions = {
      EnableEditorConfigSupport = true,
    },
    Sdk = { IncludePrereleases = true },
    RoslynExtensionsOptions = {
        EnableDecompilationSupport = true
    }
  },
}

vim.lsp.enable({'omnisharp'})

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

local omnisharpextended = require('omnisharp_extended')

vim.keymap.set('n', '<leader>od', omnisharpextended.lsp_definition,
  { noremap = true, silent = true, desc = 'omnisharp definition' })
vim.keymap.set('n', '<leader>ot', omnisharpextended.lsp_type_definition,
  { noremap = true, silent = true, desc = 'omnisharp type definition' })
vim.keymap.set('n', '<leader>of', omnisharpextended.lsp_references,
  { noremap = true, silent = true, desc = 'omnisharp references' })
vim.keymap.set('n', '<leader>oi', omnisharpextended.lsp_implementation,
  { noremap = true, silent = true, desc = 'omnisharp implementation' })

--- Stop LSP client for current buffer
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
