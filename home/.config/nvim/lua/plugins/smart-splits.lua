local init = function()
  -- smart-splits v3 dropped the IS_NVIM wezterm user var that v2 used to emit
  -- (lua/smart-splits/mux/kitty.lua). Our wezterm config (features/mux_pane_nav
  -- + super_key_nav) gates ctrl-nav and cmd-harpoon on it, so set it ourselves.
  local function set_is_nvim(value)
    io.stdout:write(("\x1b]1337;SetUserVar=IS_NVIM=%s\a"):format(vim.base64.encode(value)))
  end
  vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
    callback = function() set_is_nvim('true') end,
  })
  vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
    callback = function() set_is_nvim('false') end,
  })

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
  'smart-splits-nvim/smart-splits.nvim',
  lazy = false,
  opts = {},
  init = init
}
