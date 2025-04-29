return {
  'stevearc/oil.nvim',
  lazy = false,
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
    vim.api.nvim_set_keymap('n', '<leader>be', ':Oil<CR>', { noremap = true, silent = true, desc = 'Open file explorer' })

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = vim.schedule_wrap(function()
        if vim.v.argv[3] == '-c' then
          return
        end

        if vim.fn.argv(0) == "" then
          require("oil").open(nil, nil, nil)
        end
      end),
    })
  end,
}
