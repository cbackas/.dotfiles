return {
  -- neovim lsp stuff, keep it here so it mostly always works even if lsp.lua is busted
  {
    "folke/neodev.nvim",
    priority = 900,
  },
  -- shiftwidth stuff
  "tpope/vim-sleuth",
  -- give hints to keybinds after leader is pressed
  { 'folke/which-key.nvim', opts = {} }
}
