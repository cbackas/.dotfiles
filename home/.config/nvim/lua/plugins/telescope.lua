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
        'node_modules',
        'dist',
        'package-lock.json',
        '.git/',
        '.DS_Store',
        'lazy-lock.json'
      },

      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,

          ["<RightMouse>"] = false,
          ["<LeftMouse>"] = false,
          ["<ScrollWheelDown>"] = actions.move_selection_next,
          ["<ScrollWheelUp>"] = actions.move_selection_previous,
          ["<ScrollWheelLeft>"] = function() end,
          ["<ScrollWheelRight>"] = function() end,
        },
      },
    },
    pickers = {
      find_files = {
        hidden = true,
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

return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  cmd = "Telescope",
  keys = {
    { '<leader>?', function() require('telescope.builtin').oldfiles() end, desc = 'Find recently opened files' },
    { '<leader>/', function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = true,
        })
      end, desc = 'Fuzzily search in current buffer' },
    { '<leader>sG', function() require('telescope.builtin').git_files() end, desc = '[S]earch [G]it Files' },
    { '<leader>sh', function() require('telescope.builtin').help_tags() end, desc = '[S]earch [H]elp' },
    { '<leader>sw', function() require('telescope.builtin').grep_string() end, desc = '[S]earch current [W]ord' },
    { '<leader>sg', function() require('telescope.builtin').live_grep() end, desc = '[S]earch by [G]rep' },
    { '<leader>sd', function() require('telescope.builtin').diagnostics() end, desc = '[S]earch [D]iagnostics' },
    { '<leader>sf', function() require('telescope.builtin').find_files() end, desc = '[S]earch [F]iles' },
    { '<leader>so', function()
        require('telescope.builtin').find_files({ default_text = vim.fn.expand("%:t:r") })
      end, desc = '[S]earch [O]ther]' },
    { '<leader>gr', function() require('telescope.builtin').lsp_references() end, desc = '[G]oto [R]eferences' },
  },
  config = config,
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
