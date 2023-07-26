-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
vim.list_extend(lvim.plugins, {
  { "catppuccin/nvim",            name = "catppuccin" },
  { "mrjones2014/nvim-ts-rainbow" },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  { "mbbill/undotree" },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = false
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<tab>",
          }
        }
      })
    end,
  },
  { "tpope/vim-fugitive" },
  { "eandrju/cellular-automaton.nvim" },
})
