local wezterm = require 'wezterm' --[[@as Wezterm]]


---@param tab MuxTabObj
---@return Pane | nil
local function find_vim_pane(tab)
  for _, pane in ipairs(tab:panes_with_info()) do
    if IsVimPane(pane.pane) then
      return pane
    end
  end
  return nil
end


table.insert(Wez_Conf.keys, {
  key = 'j',
  mods = 'CMD',
  action = wezterm.action_callback(function(window, pane)
    local tab = window:active_tab()
    local vim_pane = find_vim_pane(tab)

    if IsVimPane(pane) then
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
      -- TODO fix the lua type for this - .pane is not an undefined field
      vim_pane.pane:activate()
      tab:set_zoomed(true)
    end
  end),
})
