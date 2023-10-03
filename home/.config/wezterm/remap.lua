local wezterm = require 'wezterm'
local actions = wezterm.action

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

local function split_nav(resize_or_move, key, direction)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction, 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction }, pane)
        end
      end
    end),
  }
end

-- keys
Wez_Conf.leader = { key = ' ', mods = 'CTRL', timeout_milliseconds = 1000 }
Wez_Conf.keys = {
  {
    key = '\\',
    mods = 'LEADER',
    action = actions.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = actions.SplitPane {
      direction = 'Down',
      size = { Percent = 50 },
    },
  },
  {
    key = '_',
    mods = 'LEADER|SHIFT',
    action = actions.SplitPane {
      direction = 'Down',
      size = { Percent = 30 },
    },
  },
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
}

-- F key tab navigation
for i = 1, 9 do
  table.insert(Wez_Conf.keys, {
    key = 'F' .. tostring(i),
    action = actions.ActivateTab(i - 1),
  })
end
