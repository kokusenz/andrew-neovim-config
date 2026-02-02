local M = {}

M.ollama_config = {
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

M.copilot_ollama_hybrid_config = {
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
            adapter = "ollama",
        },
        background = {
            adapter = "ollama",
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

M.copilot_opus_config = {
    interactions = {
        chat = {
            adapter = {
                name = "copilot",
                model = "claude-opus-4.5",
            },
        },
        inline = {
            adapter = {
                name = "copilot",
                model = "claude-opus-4.5",
            },
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
                model = "claude-opus-4.5",
            },
        },
        background = {
            cmd = {
                adapter = {
                    name = "copilot",
                    model = "claude-opus-4.5",
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

M.copilot_sonnet_config = {
    interactions = {
        chat = {
            adapter = {
                name = "copilot",
                model = "claude-sonnet-4.5",
            },
        },
        inline = {
            adapter = {
                name = "copilot",
                model = "claude-sonnet-4.5",
            },
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
            cmd = {
                adapter = {
                    name = "copilot",
                    model = "claude-sonnet-4.5",
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

return M
