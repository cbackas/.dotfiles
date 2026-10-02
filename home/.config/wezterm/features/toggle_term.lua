local wezterm = require 'wezterm' --[[@as Wezterm]]


---@param tab MuxTabObj
---@param is_target fun(pane: Pane): boolean
---@return Pane | nil
local function find_pane(tab, is_target)
  for _, pane in ipairs(tab:panes_with_info()) do
    if is_target(pane.pane) then
      return pane
    end
  end
  return nil
end


---@param tab MuxTabObj
---@return boolean
local function tab_is_zoomed(tab)
  for _, pane in ipairs(tab:panes_with_info()) do
    if pane.is_zoomed then
      return true
    end
  end
  return false
end


--- Build a toggle callback for a given "target" pane (e.g. vim, claude).
--- Pressing the key:
---   * from the target pane, when it is the only pane -> split a shell below it
---   * from the target pane, when other panes exist   -> toggle zoom, and when
---     unzooming drop focus to the pane below
---   * from any other pane -> jump to the target pane and zoom it (no-op if the
---     target pane does not exist)
---@param is_target fun(pane: Pane): boolean
local function make_toggle(is_target)
  return wezterm.action_callback(function(window, pane)
    local tab = window:active_tab()
    local target_pane = find_pane(tab, is_target)

    if is_target(pane) then
      -- if only 1 pane exists and it is the target, split below
      if (#tab:panes()) == 1 then
        tab:set_zoomed(false)
        pane:split {
          direction = 'Bottom',
          size = 0.333,
        }
      else -- if there are multiple panes, toggle zooming/switching between them
        local is_zoomed = tab_is_zoomed(tab)
        if is_zoomed then
          tab:set_zoomed(false)
          -- activate the non-target pane
          local down = tab:get_pane_direction('Down')
          if down then
            down:activate()
          end
        else
          tab:set_zoomed(true)
        end
      end
      return
    end

    -- Zoom to the target pane if it exists
    if target_pane then
      -- TODO fix the lua type for this - .pane is not an undefined field
      target_pane.pane:activate()
      tab:set_zoomed(true)
    end
  end)
end


table.insert(Wez_Conf.keys, {
  key = 'j',
  mods = 'CMD',
  action = make_toggle(IsVimPane),
})

table.insert(Wez_Conf.keys, {
  key = 'k',
  mods = 'CMD',
  action = make_toggle(IsClaudePane),
})
