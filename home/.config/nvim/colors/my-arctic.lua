vim.opt.background = 'dark'
vim.g.colors_name = 'my-arctic'

local lush = require('lush')
local arctic = require('lush_theme.arctic')

local new_bg = '#1b1f25'
local popup_bg = '#2E2E33'

local spec = lush.extends({ arctic }).with(function()
  -- basically replaced all instances of the background var being used with new_bg
  -- https://github.com/rockyzhang24/arctic.nvim/blob/main/lua/lush_theme/arctic.lua
  return {
    EndOfBuffer { fg = new_bg },
    SignColumn { bg = new_bg },
    Normal { fg = arctic.Normal.fg, bg = new_bg },
    TabLineSel { fg = arctic.TabLineSel.fg, bg = new_bg },
    Todo { fg = new_bg, bg = arctic.Todo.bg, gui = arctic.Todo.gui },
    Pmenu { fg = arctic.Pmenu.fg, bg = popup_bg },
    SnacksPicker { fg = arctic.Pmenu.fg, bg = new_bg },
    NormalFloat { fg = arctic.Normal.fg, bg = new_bg }
  }
end)

lush(spec)
