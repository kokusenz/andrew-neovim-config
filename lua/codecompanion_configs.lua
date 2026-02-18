local M = {}

-- Shared configurations
local function get_ollama_adapter()
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
        config.adapters = get_ollama_adapter()
    end

    return config
end

-- Configurations
M.ollama_config = build_config({
    chat_adapter = "ollama",
    inline_adapter = "ollama",
    cmd_adapter = "ollama",
    background_adapter = "ollama",
    include_ollama_adapter = true,
})

M.copilot_ollama_hybrid_config = build_config({
    chat_adapter = copilot_adapter("claude-sonnet-4.6"),
    inline_adapter = "ollama",
    cmd_adapter = "ollama",
    background_adapter = "ollama",
    include_ollama_adapter = true,
})

M.copilot_opus_config = build_config({
    chat_adapter = copilot_adapter("claude-opus-4.6"),
    inline_adapter = copilot_adapter("claude-opus-4.6"),
    cmd_adapter = copilot_adapter("claude-opus-4.6"),
    background = {
        cmd = {
            adapter = copilot_adapter("claude-opus-4.6"),
        },
    },
})

M.copilot_sonnet_config = build_config({
    chat_adapter = copilot_adapter("claude-sonnet-4.6"),
    inline_adapter = copilot_adapter("claude-sonnet-4.6"),
    cmd_adapter = copilot_adapter("claude-sonnet-4.6"),
    background = {
        cmd = {
            adapter = copilot_adapter("claude-sonnet-4.6"),
        },
    },
})

return M
