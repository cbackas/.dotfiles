local wezterm = require 'wezterm' --[[@as Wezterm]]
local actions = wezterm.action

--
-- Mux pane navigation
---@param resize_or_move "resize" | "move"
---@param key "k" | "j" | "l" | ";" | "B" // tbh i forget what the B is for
---@param direction "Up" | "Down" | "Left" | "Right"
local function split_nav(resize_or_move, key, direction)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if pane:get_user_vars().IS_NVIM == 'true' then
        -- pass the keys through to vim/nvim
        if (key == ';') then
          key = 'B'
        end
        win:perform_action(actions.SendKey({ key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' }), pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action(actions.AdjustPaneSize({ direction, 3 }), pane)
        else
          win:perform_action(actions.ActivatePaneDirection(direction), pane)
        end
      end
    end),
  }
end

-- apply the maps using the split_nav helper function
ConcatTables(Wez_Conf.keys, {
  -- move between split panes
  split_nav('move', 'k', 'Up'),
  split_nav('move', 'j', 'Down'),
  split_nav('move', 'l', 'Left'),
  split_nav('move', ';', 'Right'),
  -- resize panes
  split_nav('resize', 'k', 'Up'),
  split_nav('resize', 'j', 'Down'),
  split_nav('resize', 'l', 'Left'),
  split_nav('resize', ';', 'Right'),
})

--
-- Cross-boundary nav/resize (nvim edge -> wezterm pane)
--
-- smart-splits.nvim v3 dropped built-in mux support. Our nvim config registers a
-- tiny inline backend (no plugin) that, when nvim hits its own edge, writes a
-- SMART_SPLITS_REQ user var carrying { action = 'move'|'resize', dir, amount }.
-- We handle it here so edge-crossing nav/resize works again.
local DIR = { left = 'Left', right = 'Right', up = 'Up', down = 'Down' }

wezterm.on('user-var-changed', function(window, pane, name, value)
  if name ~= 'SMART_SPLITS_REQ' then
    return
  end
  local ok, req = pcall(wezterm.json_parse, value)
  if not ok or type(req) ~= 'table' then
    return
  end
  local direction = DIR[req.dir]
  if direction == nil then
    return
  end
  if req.action == 'resize' then
    window:perform_action(actions.AdjustPaneSize({ direction, req.amount or 1 }), pane)
  else
    -- no-op if there's no pane that way, i.e. "stop" at the edge
    window:perform_action(actions.ActivatePaneDirection(direction), pane)
  end
end)
