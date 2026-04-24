local configs = {}

-- Shared configurations
local function get_local_ollama_adapter()
    return {
        http = {
            ollama = function()
                return require("codecompanion.adapters").extend("ollama", {
                    env = {
                        url = "http://localhost:11434",
                    },
                    headers = {
                        ["Content-Type"] = "application/json",
                    },
                    parameters = {
                        sync = true,
                    },
                    schema = {
                        model = {
                            default = "qwen3-coder:30b",
                        },
                    },
                })
            end,
        },
    }
end

local function get_ollama_adapter()
    return {
        http = {
            ollama = function()
                return require("codecompanion.adapters").extend("ollama", {
                    env = {
                        url = "https://ollama.com",
                        -- note that i did export OLLAMA_API_KEY = <api key> in my zshrc; not sure if that is important
                        api_key = "OLLAMA_API_KEY"
                    },
                    headers = {
                        ["Content-Type"] = "application/json",
                        ["Authorization"] = "Bearer " .. 'a4c3429c29bd4818ada6bef0318ff384.c-pikuz-U3BD-vxeVOs4Q7bq',
                    },
                    parameters = {
                        sync = true,
                    },
                    schema = {
                        model = {
                            default = "kimi-k2:1t",
                        },
                    },
                })
            end,
        },
    }
end

local inline_keymaps = {
    accept_change = {
        modes = { n = "ga" },
        description = "Accept the suggested change",
    },
    reject_change = {
        modes = { n = "gr" },
        opts = { nowait = true },
        description = "Reject the suggested change",
    },
}

local display_config = {
    chat = {
        window = {
            layout = "float",
        }
    },
    inline = {
        layout = "vertical",
    },
}

-- :CodeCompanionHistory to use the extension
local extensions_config = {
    history = {
        enabled = true, -- defaults to true
        opts = {
            dir_to_save = vim.fn.expand('~/.local/share/nvim') .. "/codecompanion_chats.json",
        }
    }
}

-- Helper to create copilot adapter config
local function copilot_adapter(model)
    return {
        name = "copilot",
        model = model,
    }
end

-- Helper to build full config
local function build_config(opts)
    local config = {
        interactions = {
            chat = {
                adapter = opts.chat_adapter,
            },
            inline = {
                adapter = opts.inline_adapter,
                keymaps = inline_keymaps,
            },
            cmd = {
                adapter = opts.cmd_adapter,
            },
            background = opts.background or {
                adapter = opts.background_adapter,
            },
        },
        display = display_config,
        extensions = extensions_config
    }

    if opts.include_ollama_adapter then
        --config.adapters = get_local_ollama_adapter()
        config.adapters = get_ollama_adapter()
    end

    return config
end

-- Configurations
configs.ollama_config = build_config({
    chat_adapter = "ollama",
    inline_adapter = "ollama",
    cmd_adapter = "ollama",
    background_adapter = "ollama",
    include_ollama_adapter = true,
})

configs.copilot_ollama_hybrid_config = build_config({
    chat_adapter = copilot_adapter("claude-sonnet-4.6"),
    inline_adapter = "ollama",
    cmd_adapter = "ollama",
    background_adapter = "ollama",
    include_ollama_adapter = true,
})

configs.copilot_opus_config = build_config({
    chat_adapter = copilot_adapter("claude-opus-4.7"),
    inline_adapter = copilot_adapter("claude-opus-4.7"),
    cmd_adapter = copilot_adapter("claude-opus-4.7"),
    background = {
        cmd = {
            adapter = copilot_adapter("claude-opus-4.7"),
        },
    },
})

configs.copilot_sonnet_config = build_config({
    chat_adapter = copilot_adapter("claude-sonnet-4.6"),
    inline_adapter = copilot_adapter("claude-sonnet-4.6"),
    cmd_adapter = copilot_adapter("claude-sonnet-4.6"),
    background = {
        cmd = {
            adapter = copilot_adapter("claude-sonnet-4.6"),
        },
    },
})

local codecompanion = require("codecompanion")
local codecompanion_config = {
    ['sonnet'] = configs.copilot_sonnet_config,
    ['opus'] = configs.copilot_opus_config,
    ['ollama_hybrid'] = configs.copilot_ollama_hybrid_config,
    ['ollama'] = configs.ollama_config
}
codecompanion.setup(codecompanion_config[require('config').codecompanion])

function CodeCompanionBufferExists()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match("CodeCompanion") then
      return true
    end
  end
  return false
end

function ToggleCodeCompanionChat()
    if CodeCompanionBufferExists() then
        vim.cmd("CodeCompanionChat Toggle")
    else
        vim.cmd("CodeCompanionChat")
    end
end

vim.keymap.set('n', "<leader>cc", function()
    ToggleCodeCompanionChat()
end, { noremap = true, silent = true })

vim.cmd([[cabbrev cch CodeCompanionHistory]])

-- ap for action pallete
vim.keymap.set('n', "<leader>ap", function()
    vim.cmd("CodeCompanionActions")
end, { noremap = true, silent = true })

vim.keymap.set('v', "<leader>ac", function()
    vim.cmd("CodeCompanionChat Add")
end, { noremap = true, silent = true })

require('copilot').setup()

vim.keymap.set('n', '<leader>ow', function()
  vim.notify("Warming up Ollama...")
  vim.fn.jobstart({
    'curl', '-s', 'http://localhost:11434/api/generate',
    '-d', '{"model":"qwen3-coder:30b","prompt":"Write a haiku about code","stream":false}'
  }, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("Ollama warmed up!")
      else
        vim.notify("Ollama warmup failed", vim.log.levels.ERROR)
      end
    end
  })
end, { desc = "Warm up Ollama" })
