local init = function()
  -- resizing splits
  vim.keymap.set('n', '<A-l>', require('smart-splits').resize_left)
  vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
  vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
  vim.keymap.set('n', '<A-B>', require('smart-splits').resize_right)

  -- moving between splits
  vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_left)
  vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
  vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
  vim.keymap.set('n', '<C-B>', require('smart-splits').move_cursor_right, { noremap = true })
end

return {
  'mrjones2014/smart-splits.nvim',
  lazy = false,
  opts = {},
  init = init
}
