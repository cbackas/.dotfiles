require('cback.set')
require('cback.remap')
require('cback.lazy')
require('cback.PCDSync').setup()
require('cback.lsp')
require('cback.filetypes')
require('cback.autotest')
require('cback.right-click')
require('cback.RedactJSON')

-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank { higroup = 'Visual', timeout = 500 }
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})

local no_whitespace_group = vim.api.nvim_create_augroup('NoWhiteSpace', {})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = no_whitespace_group,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- start treesitter
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
