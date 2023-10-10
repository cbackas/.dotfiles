-- if 'DISABLE_COPILOT' env var is set, don't load copilot
if os.getenv('DISABLE_COPILOT') then
  return
end

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
})

local copilot_suggestion = require("copilot.suggestion")
vim.keymap.set('i', '<Tab>', function()
  if copilot_suggestion.is_visible() then
    copilot_suggestion.accept_line()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', false)
  end
end, { noremap = true })
