require('config.keybindings')
require('config.lsp')
require('config.plugins')

-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true

-- vim.cmd [[
--   autocmd BufRead,BufNewFile ~/.config/tmux/plugins.conf setfiletype tmux
--   autocmd BufRead,BufNewFile ~/.config/tmux/keybinds.conf setfiletype tmux
-- ]]

-- general
lvim.log.level = "info"
lvim.format_on_save = {
  enabled = true,
  timeout = 1000,
}

-- -- Change theme settings
lvim.colorscheme = "catppuccin"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.filters.dotfiles = false
lvim.builtin.nvimtree.setup.filters.custom = { ".git" }
lvim.builtin.cmp.formatting.max_width = 350

-- local has_words_before = function()
--   if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
--   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--   return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
-- end
-- lvim.builtin.cmp.mapping = {
--   ["<Tab>"] = vim.schedule_wrap(function(fallback)
--     if lvim.builtin.cmp.visible() and has_words_before() then
--       lvim.builtin.cmp.select_next_item({ behavior = lvim.builtin.cmp.SelectBehavior.Select })
--     else
--       fallback()
--     end
--   end),
-- }

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true
lvim.builtin.treesitter.rainbow.enable = true

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- always installed on startup, useful for parsers without a strict filetype
-- lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }
