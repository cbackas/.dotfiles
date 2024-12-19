local config = function()
  local actions = require "telescope.actions"

  require('telescope').setup {
    defaults = {
      selection_strategy = "reset",
      sorting_strategy = "ascending",
      scroll_strategy = "cycle",
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
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {
          -- even more opts
        }
      }
    }
  }

  -- Enable telescope fzf native, if installed
  pcall(require('telescope').load_extension, 'ui-select')
end

return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  config = config,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
  }
}
