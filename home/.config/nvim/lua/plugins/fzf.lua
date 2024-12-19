local function init()
  local fzf = require('fzf-lua')

  vim.keymap.set('n', '<leader>?', fzf.oldfiles, { desc = 'Find recently opened files' })
  -- vim.keymap.set('n', '<leader><space>', fzf.buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
    fzf.lgrep_curbuf()
  end, { desc = 'Fuzzily search in current buffer' })

  vim.keymap.set('n', '<leader>sh', function()
    fzf.help_tags()
  end, { desc = '[S]earch [H]elp' })

  vim.keymap.set('n', '<leader>sw', function()
    fzf.grep_cword()
  end, { desc = '[S]earch current [W]ord' })

  vim.keymap.set('n', '<leader>sg', function()
    fzf.live_grep()
  end, { desc = '[S]earch by [G]rep' })

  vim.keymap.set('n', '<leader>sf', function()
    fzf.files()
  end, { desc = '[S]earch [F]iles' })

  -- TODO how do you shove a search term into fzf.files?
  -- vim.keymap.set('n', '<leader>so', function()
  --   fzf.files({ vim.fn.expand("%:t:r") })
  -- end, { desc = '[S]earch [O]ther' })
end

return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = init,
  opts = {
  },
}
