local init = function()
  vim.keymap.set('n', '<leader>td', function() require("trouble").toggle("document_diagnostics") end,
    { desc = 'Open diagnostics list' })
  vim.keymap.set('n', '<leader>tq', function() require("trouble").toggle("quickfix") end,
    { desc = 'Open quickfix list' })

  vim.api.nvim_create_user_command('Rg', function(input)
    -- Use the current word under the cursor as the default search term if none is provided
    local search_term = input.args ~= "" and input.args or vim.fn.expand("<cword>")
    -- Define the command to use ripgrep, ensuring to escape special characters in the search term
    local rg_command = string.format("rg --vimgrep %s %s", vim.fn.shellescape(search_term), ".")

    -- Execute ripgrep and capture the output
    vim.fn.setqflist({}, ' ', {
      title = 'Search Results',
      lines = vim.fn.systemlist(rg_command),
      efm = '%f:%l:%c:%m',
    })

    -- Open the quickfix list to show the results
    require("trouble").open("quickfix")
  end, { nargs = '?', complete = "file" })
end

return {
  'folke/trouble.nvim',
  opts = {
    mode = 'document_diagnostics',
    auto_open = false,
    auto_close = true,
    auto_preview = true,
  },
  init = init,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  }
}
