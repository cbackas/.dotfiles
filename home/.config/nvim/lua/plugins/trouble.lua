local init = function()
  vim.keymap.set('n', '<leader>td', function() require("trouble").toggle("document_diagnostics") end,
    { desc = 'Open diagnostics list' })
  vim.keymap.set('n', '<leader>tq', function() require("trouble").toggle("quickfix") end,
    { desc = 'Open quickfix list' })
end

local M = {
  'folke/trouble.nvim',
  opts = {
    mode = 'document_diagnostics',
    auto_open = false,
    auto_close = true,
    auto_preview = true,
  },
  init = init,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  }
}

return { M }
