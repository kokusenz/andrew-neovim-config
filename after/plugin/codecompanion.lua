local configs = require("codecompanion_configs")

local codecompanion = require("codecompanion")
codecompanion.setup(configs.copilot_ollama_hybrid_config)

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
