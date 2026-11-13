-- Emit a wezterm user var via OSC 1337. Writing to io.stdout passes the escape
-- straight through to wezterm -- the same channel that makes IS_NVIM (and thus
-- ctrl-nav + cmd-harpoon forwarding) work.
local function emit_user_var(name, value)
  io.stdout:write(("\x1b]1337;SetUserVar=%s=%s\a"):format(name, vim.base64.encode(value)))
end

-- Inline multiplexer backend -- no extra plugin. smart-splits v3 moved mux
-- support into separate backend plugins, but `mux.backend` also accepts a
-- backend table directly (smart-splits/backend.lua validates a non-string spec
-- and uses it as-is). At an nvim edge, core calls move()/resize(); we write a
-- SMART_SPLITS_REQ user var that our wezterm config (features/mux_pane_nav)
-- turns into ActivatePaneDirection/AdjustPaneSize. Returning true tells core we
-- handled the edge so it won't wrap back inside nvim.
local wezterm_backend = {
  name = 'wezterm-inline',
  protocol_version = '3.0.0',
  detect = function()
    return vim.env.WEZTERM_PANE ~= nil and #vim.env.WEZTERM_PANE > 0
  end,
  move = function(direction)
    emit_user_var('SMART_SPLITS_REQ', vim.json.encode({ action = 'move', dir = direction }))
    return true
  end,
  resize = function(direction, opts)
    emit_user_var('SMART_SPLITS_REQ', vim.json.encode({
      action = 'resize',
      dir = direction,
      amount = math.floor((opts and opts.amount) or 1),
    }))
    return true
  end,
}

local function init()
  -- smart-splits v3 dropped the IS_NVIM wezterm user var that v2 used to emit
  -- (lua/smart-splits/mux/kitty.lua). Our wezterm config (features/mux_pane_nav
  -- + super_key_nav) gates ctrl-nav and cmd-harpoon on it, so set it ourselves.
  vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
    callback = function() emit_user_var('IS_NVIM', 'true') end,
  })
  vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
    callback = function() emit_user_var('IS_NVIM', 'false') end,
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
  opts = {
    mux = { backend = wezterm_backend },
  },
  init = init,
}
