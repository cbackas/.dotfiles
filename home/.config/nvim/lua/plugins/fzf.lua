local function init()
  local fzf = require('fzf-lua')

  -- Open telescope find_files if no arguments are passed to nvim
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      if vim.fn.argv(0) == "" then
        fzf.files()
      end
    end,
  })

  vim.keymap.set('n', '<leader>?', function()
    fzf.oldfiles({
      cwd_only = true,
      -- ensure files exist
      stat_file = true,
    })
  end, { desc = 'Find recently opened files' })
  vim.keymap.set('n', '<leader>/', fzf.lgrep_curbuf, { desc = 'Fuzzily search in current buffer' })
  vim.keymap.set('n', '<leader>sh', fzf.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sb', fzf.buffers, { desc = '[S] Find existing [B]uffers' })
  vim.keymap.set('n', '<leader>sg', fzf.grep_project, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })

  -- TODO how do you shove a search term into fzf.files?
  -- vim.keymap.set('n', '<leader>so', function()
  --   fzf.files({ search = vim.fn.expand("%:t:r") })
  -- end, { desc = '[S]earch [O]ther' })

  -- INFO use fzf as the default ui selector
  fzf.register_ui_select(function(_, items)
    local min_h, max_h = 0.15, 0.70
    local h = (#items + 4) / vim.o.lines
    if h < min_h then
      h = min_h
    elseif h > max_h then
      h = max_h
    end
    return { winopts = { height = h, width = 0.60, row = 0.40 } }
  end)
end

return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = init,
  opts = {
    keymap = {
      fzf = {
        -- use cltr-q to select all items and convert to quickfix list
        ["ctrl-q"] = "select-all+accept",
      },
    },
    winopts = {
      height = 0.85,
      width  = 0.90,
      row    = 0.35,
      col    = 0.55,
    },
    files = {
      cwd_prompt = false,
      prompt = 'fzf❯ '
    },
    grep = {
      file_ignore_patterns = { ".-package%-lock%.json$", "Cargo%.lock$", ".-node_modules/.-", ".-LICENSE$" }
    }
  },
}
