return {
  "rockyzhang24/arctic.nvim",
  dependencies = { "rktjmp/lush.nvim" },
  name = "arctic",
  branch = "main",
  commit = "09e2298",
  priority = 1000,
  config = function()
    vim.cmd("colorscheme my-arctic")
  end
}
