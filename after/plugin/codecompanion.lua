require("codecompanion").setup({
    strategies = {
        chat = {
            adapter = {
                name = "copilot",
                model = "Claude Sonnet 4.5"
            }
        },
        inline = {
            adapter = "ollama",
            model = "qwen3-coder:30b",
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
            adapter = "copilot"
        },
        background = {
            adapter = {
                name = "copilot",
                model = "Claude Sonnet 4.5"
            }
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
})

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
    copilot_model = "Claude Opus 4.5"
})
