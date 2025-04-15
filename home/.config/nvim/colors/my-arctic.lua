vim.opt.background = 'dark'
vim.g.colors_name = 'my-arctic'

local lush = require('lush')
local arctic = require('lush_theme.arctic')

local dark_blueish_grey = '#1b1f25'
local blueish_grey = '#2E2E33'
local light_blueish_grey = "#b0b2bf"

local spec = lush.extends({ arctic }).with(function()
  -- basically replaced all instances of the background var being used with new_bg
  -- https://github.com/rockyzhang24/arctic.nvim/blob/main/lua/lush_theme/arctic.lua
  return {
    EndOfBuffer { fg = dark_blueish_grey },
    SignColumn { bg = dark_blueish_grey },
    Normal { fg = arctic.Normal.fg, bg = dark_blueish_grey },
    TabLineSel { fg = arctic.TabLineSel.fg, bg = dark_blueish_grey },
    Todo { fg = dark_blueish_grey, bg = arctic.Todo.bg, gui = arctic.Todo.gui },
    Pmenu { fg = arctic.Pmenu.fg, bg = blueish_grey },
    SnacksPicker { fg = arctic.Pmenu.fg, bg = dark_blueish_grey },
    NormalFloat { fg = arctic.Normal.fg, bg = dark_blueish_grey },
    -- harpoon
    HarpoonActive { fg = arctic.Identifier.fg, bg = blueish_grey },
    HarpoonActiveFolder { fg = light_blueish_grey, bg = blueish_grey },
    HarpoonNumberActive { fg = arctic.Function.fg, bg = blueish_grey },
    HarpoonInactive { fg = arctic.LineNr.fg, bg = arctic.TabLine.bg },
    HarpoonInactiveFolder { fg = arctic.LineNr.fg, bg = arctic.TabLine.bg },
    HarpoonNumberInactive { fg = arctic.Special.fg, bg = arctic.TabLine.bg },
    TabLineFill { fg = "white", bg = arctic.TabLineFill.bg, sp = arctic.TabLineFill.sp },
  }
end)

lush(spec)
