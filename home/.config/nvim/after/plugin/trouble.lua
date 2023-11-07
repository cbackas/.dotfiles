require('trouble').setup {
  mode = 'document_diagnostics',
  auto_open = false,
  auto_close = true,
  auto_preview = true,
}

vim.keymap.set('n', '<leader>td', function() require("trouble").toggle("document_diagnostics") end,
  { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>tq', function() require("trouble").toggle("quickfix") end,
  { desc = 'Open quickfix list' })
