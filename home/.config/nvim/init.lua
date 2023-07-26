require('cback')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local no_whitespace_group = vim.api.nvim_create_augroup('NoWhiteSpace', {})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = no_whitespace_group,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
