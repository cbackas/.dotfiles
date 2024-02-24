local config = function()
  require("copilot").setup({
    panel = {
      enabled = false
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<C-y>",
      }
    },
    filetypes = {
      gitcommit = true,
      gitrebase = true,
      dotenv = false,
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
  vim.keymap.set('i', '<C-y>', function() copilot_suggestion.accept_line() end, { noremap = true })
end

return {
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
