local config = function()
  local actions = require "telescope.actions"

  -- See `:help telescope` and `:help telescope.setup()`
  require('telescope').setup {
    defaults = {
      prompt_prefix = "> ",
      selection_caret = "> ",
      entry_prefix = "  ",
      multi_icon = "<>",

      winblend = 0,

      layout_strategy = "horizontal",
      layout_config = {
        width = 0.95,
        height = 0.85,
        -- preview_cutoff = 120,
        prompt_position = "top",

        horizontal = {
          preview_width = function(_, cols, _)
            if cols > 200 then
              return math.floor(cols * 0.4)
            else
              return math.floor(cols * 0.6)
            end
          end,
          preview_height = 0.5,
        },

        vertical = {
          width = 0.9,
          height = 0.95,
          preview_height = 0.5,
        },

        flex = {
          horizontal = {
            preview_width = 0.9,
          },
        },
      },

      selection_strategy = "reset",
      sorting_strategy = "ascending",
      scroll_strategy = "cycle",
      color_devicons = true,
      file_ignore_patterns = {
        'node_modules', 'dist', 'package-lock.json',
        '.git/',
        '.DS_Store',
        'lazy-lock.json'
      },

      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,

          ["<RightMouse>"] = actions.close,
          ["<LeftMouse>"] = actions.select_default,
          ["<ScrollWheelDown>"] = actions.move_selection_next,
          ["<ScrollWheelUp>"] = actions.move_selection_previous,
          ["<ScrollWheelLeft>"] = function() end,
          ["<ScrollWheelRight>"] = function() end,
        },
      },
    },
    pickers = {
      find_files = {
        hidden = false,
      }
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {
          -- even more opts
        }
      }
    }
  }

  -- Enable telescope fzf native, if installed
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'git_worktree')
  pcall(require('telescope').load_extension, 'ui-select')
end

local init = function()
  -- See `:help telescope.builtin`
  vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = 'Find recently opened files' })
  -- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = true,
    })
  end, { desc = 'Fuzzily search in current buffer' })

  -- Set telescope keybinds
  vim.keymap.set('n', '<leader>sG', require('telescope.builtin').git_files, { desc = '[S]earch [G]it Files' })
  vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>so', function()
    require('telescope.builtin').find_files({ default_text = vim.fn.expand("%:t:r") })
  end, { desc = '[S]earch [O]ther]' })

  -- Open telescope find_files if no arguments are passed to nvim
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      if vim.fn.argv(0) == "" then
        require("telescope.builtin").find_files()
      end
    end,
  })
end

return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  config = config,
  init = init,
  dependencies = {
    'nvim-lua/plenary.nvim',

    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },

    'nvim-telescope/telescope-ui-select.nvim',

    'nvim-telescope/telescope-symbols.nvim'
  }
}
