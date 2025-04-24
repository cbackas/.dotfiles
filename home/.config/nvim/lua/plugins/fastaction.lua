return {
  'Chaitanyabsprip/fastaction.nvim',
  ---@module "fastaction"
  ---@type FastActionConfig
  opts = {
    dismiss_keys = { "<Esc>", "j", "k", "<c-c>", "q" },
    brackets = { '', '' },
    popup = {
      title = false,
      border = "rounded",
      hide_cursor = true,
    }
  },
}
