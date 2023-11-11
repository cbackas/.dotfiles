require("oil").setup({
  default_file_explorer = true,
  view_options = {
    show_hidden = true,
    is_hidden_file = function(name, bufnr)
      return name ~= ".." and vim.startswith(name, ".")
    end,
  }
})

vim.api.nvim_set_keymap('n', '<leader>be', ':Oil<CR>', { noremap = true, silent = true })
