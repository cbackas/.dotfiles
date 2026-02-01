vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

return {
  'kevinhwang91/nvim-ufo',
  event = "BufReadPost",
  dependencies = {
    'kevinhwang91/promise-async',
  },
  opts = {
    provider_selector = function(_, _, _)
      return { 'lsp', 'indent' }
    end
  },
  keys = {
    { 'zR', function() require('ufo').openAllFolds() end, desc = 'Open all folds' },
    { 'zM', function() require('ufo').closeAllFolds() end, desc = 'Close all folds' },
  },
}
