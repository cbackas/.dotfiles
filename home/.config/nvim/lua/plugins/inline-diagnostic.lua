return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000, -- needs to be loaded in first
  opts = {
    preset = "simple",
    options = {
      show_source = true,
      multiple_diag_under_cursor = true,
      multilines = {
        enabled = true,
        always_show = true,
      },
    }
  },
  init = function()
    vim.diagnostic.config({ virtual_text = false })
  end
  -- config = function()
  --   require('tiny-inline-diagnostic').setup()
  -- end
}
