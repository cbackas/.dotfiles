local config = function()
  require("copilot").setup({
    panel = {
      enabled = false
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<tab>",
      }
    },
    filetypes = {
      gitcommit = true,
      gitrebase = true,
      sh = function()
        if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
          -- disable for .env files
          return false
        end
        return true
      end,
    }
  })

  local copilot_suggestion = require("copilot.suggestion")
  vim.keymap.set('i', '<Tab>', function()
    if copilot_suggestion.is_visible() then
      copilot_suggestion.accept_line()
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', false)
    end
  end, { noremap = true })
end

local M = {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = config,
  cond = function()
    -- if 'DISABLE_COPILOT' env var is set, don't load copilot
    local disable_copilot = os.getenv('DISABLE_COPILOT')
    local is_copilot_disabled = disable_copilot == '1' or disable_copilot == 'yes' or disable_copilot == 'true'
    return not is_copilot_disabled
  end
}

return { M }
