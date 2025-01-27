local wezterm = require 'wezterm' --[[@as Wezterm]]
local actions = wezterm.action

---@param pane Pane
---@return boolean
local function is_vim(pane)
  local process_info = pane:get_foreground_process_info()
  local process_name = process_info and process_info.name

  return process_name == 'nvim' or process_name == 'vim' or process_name == 'nvim.exe' or process_name == 'vim.exe'
end

---@param tab MuxTabObj
---@return Pane | nil
local function find_vim_pane(tab)
  for _, pane in ipairs(tab:panes_with_info()) do
    if is_vim(pane.pane) then
      return pane
    end
  end
  return nil
end

-- keys
Wez_Conf.leader = { key = ' ', mods = 'CTRL', timeout_milliseconds = 1000 }
Wez_Conf.keys = {
  { key = 'L', mods = 'CTRL', action = actions.ShowDebugOverlay },
  -- close current pane
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- close current tab
  {
    key = 'w',
    mods = 'CMD|SHIFT',
    action = actions.CloseCurrentTab { confirm = true },
  },
  -- vertical split
  {
    key = '\\',
    mods = 'LEADER',
    action = actions.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- horizontal split (50%)
  {
    key = '-',
    mods = 'LEADER',
    action = actions.SplitPane {
      direction = 'Down',
      size = { Percent = 50 },
    },
  },
  -- horizontal split (30%) (for lil terminals under my main window)
  {
    key = '_',
    mods = 'LEADER|SHIFT',
    action = actions.SplitPane {
      direction = 'Down',
      size = { Percent = 30 },
    },
  },
  -- rename active tab
  {
    key = 'E',
    mods = 'CTRL|SHIFT',
    action = actions.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  -- rotate panes
  {
    key = 'b',
    mods = 'CMD',
    action = actions.RotatePanes 'Clockwise',
  },
  {
    key = 'j',
    mods = 'CMD',
    action = wezterm.action_callback(function(window, pane)
      local tab = window:active_tab()
      local vim_pane = find_vim_pane(tab)

      if is_vim(pane) then
        -- if only 1 pane exists and it is vim, split below
        if (#tab:panes()) == 1 then
          -- Open pane below if when there is only one pane and it is vim
          tab:set_zoomed(false)
          pane:split {
            direction = 'Bottom',
            size = 0.333,
          }
        else -- if there are multiple panes, toggle zooming/switching between them
          local is_zoomed = tab:panes_with_info()[1].is_zoomed
          if is_zoomed then
            tab:set_zoomed(false)
            -- activate the non-vim pane
            tab:get_pane_direction('Down'):activate()
          else
            tab:set_zoomed(true)
          end
        end
        return
      end

      -- Zoom to vim pane if it exists
      if vim_pane then
        vim_pane:activate()
        tab:set_zoomed(true)
      end
    end),
  },
}
