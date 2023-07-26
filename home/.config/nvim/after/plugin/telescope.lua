-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
    layout_config = {
      horizontal = {
        width = 0.9,
        height = 0.9,
      },
      vertical = {
        width = 0.9,
        height = 0.9,
      }
    },
    file_ignore_patterns = {
      'node_modules', 'dist', 'package-lock.json',
      '.git',
      '.DS_Store'
    }
  },
  pickers = {
    find_files = {
      hidden = true,
    }
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

-- Set telescope keybinds
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sf', function()
  require('telescope.builtin').find_files(require('telescope.themes').get_dropdown {
    winblend = 5,
    previewer = true,
  })
end, { desc = '[S]earch [F]iles' })

-- Open telescope find_files if no arguments are passed to nvim
vim.cmd([[
  autocmd VimEnter * if argc() == 0 | silent! call timer_start(100, {-> luaeval("require('telescope.builtin').find_files()")}) | endif
]])
