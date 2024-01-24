local M = {
  "rockyzhang24/arctic.nvim",
  dependencies = { "rktjmp/lush.nvim" },
  name = "arctic",
  branch = "main",
  priority = 1000,
  config = function()
    vim.cmd("colorscheme my-arctic")
  end
}

return { M }
