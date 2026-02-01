local ollama_config = {
    adapters = {
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
    },
    interactions = {
        chat = {
            adapter =  "ollama",
        },
        inline = {
            adapter = "ollama",
            keymaps = {
                accept_change = {
                    modes = { n = "ga" },
                    description = "Accept the suggested change",
                },
                reject_change = {
                    modes = { n = "gr" },
                    opts = { nowait = true },
                    description = "Reject the suggested change",
                },
            },
        },
        cmd = {
            adapter =  "ollama",
        },
        background = {
            adapter =  "ollama",
        },
    },
    display = {
        chat = {
            window = {
                layout = "float",
            }
        },
        inline = {
            layout = "vertical",
        },
    },
}

local copilot_ollama_hybrid_config = {
    adapters = {
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
    },
    interactions = {
        chat = {
            adapter = {
                name = "copilot",
                model = "claude-sonnet-4.5",
            },
        },
        inline = {
            adapter = "ollama",
            keymaps = {
                accept_change = {
                    modes = { n = "ga" },
                    description = "Accept the suggested change",
                },
                reject_change = {
                    modes = { n = "gr" },
                    opts = { nowait = true },
                    description = "Reject the suggested change",
                },
            },
        },
        cmd = {
            adapter = {
                name = "copilot",
                model = "claude-sonnet-4.5",
            },
        },
        background = {
            adapter = {
                name = "copilot",
                model = "claude-sonnet-4.5",
            },
        },
    },
    display = {
        chat = {
            window = {
                layout = "float",
            }
        },
        inline = {
            layout = "vertical",
        },
    },
}

local copilot_opus_config = {
    strategies = {
        chat = {
            adapter = {
                name = "copilot",
                model = "Claude Opus 4.5",
            },
        },
        inline = {
            adapter = "copilot",
            keymaps = {
                accept_change = {
                    modes = { n = "ga" },
                    description = "Accept the suggested change",
                },
                reject_change = {
                    modes = { n = "gr" },
                    opts = { nowait = true },
                    description = "Reject the suggested change",
                },
            },
        },
        cmd = {
            adapter = {
                name = "copilot",
                model = "Claude Opus 4.5",
            },
        },
        background = {
            cmd = {
                adapter = {
                    name = "copilot",
                    model = "Claude Opus 4.5",
                },
            },
        },
    },
    display = {
        chat = {
            window = {
                layout = "float",
            }
        },
        inline = {
            layout = "vertical",
        },
    },
}

require("codecompanion").setup(ollama_config)

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

vim.cmd([[cabbrev cc CodeCompanion]])

-- ap for action pallete
vim.keymap.set('n', "<leader>ap", function()
    vim.cmd("CodeCompanionActions")
end, { noremap = true, silent = true })

vim.keymap.set('v', "<leader>ac", function()
    vim.cmd("CodeCompanionChat Add")
end, { noremap = true, silent = true })

require('copilot').setup({
    model = "claude-sonnet-4.5"
})
