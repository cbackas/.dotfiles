local M = {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, bufnr)
        return name ~= ".." and vim.startswith(name, ".")
      end,
    }
  },
  init = function()
    vim.api.nvim_set_keymap('n', '<leader>be', ':Oil<CR>', { noremap = true, silent = true })
  end,
}

return { M }
