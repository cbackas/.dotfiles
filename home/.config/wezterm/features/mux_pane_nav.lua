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
  split_nav('move', 'l', 'Right'),
  split_nav('move', ';', 'Left'),
  -- resize panes
  split_nav('resize', 'k', 'Up'),
  split_nav('resize', 'j', 'Down'),
  split_nav('resize', 'l', 'Right'),
  split_nav('resize', ';', 'Left'),
})
