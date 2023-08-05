local wilder = require('wilder')

wilder.setup {
  modes = { ':', '/', '?' },
}

wilder.set_option('renderer', wilder.wildmenu_renderer({
  highlighter = wilder.basic_highlighter(),
  separator = ' · ',
  left = { ' ', wilder.wildmenu_spinner(), ' ' },
  right = { ' ', wilder.wildmenu_index() },
}))

-- wilder.set_option('renderer', wilder.popupmenu_renderer({
--   highlighter = {
--     wilder.lua_pcre2_highlighter(), -- requires `luarocks install pcre2`
--     wilder.lua_fzy_highlighter(),   -- requires fzy-lua-native vim plugin found
--                                     -- at https://github.com/romgrk/fzy-lua-native
--   },
--   highlights = {
--     accent = wilder.make_hl('WilderAccent', 'Pmenu', {{a = 1}, {a = 1}, {foreground = '#f4468f'}}),
--   },
-- }))
--
local gradient = {
  '#f4468f', '#fd4a85', '#ff507a', '#ff566f', '#ff5e63',
  '#ff6658', '#ff704e', '#ff7a45', '#ff843d', '#ff9036',
  '#f89b31', '#efa72f', '#e6b32e', '#dcbe30', '#d2c934',
  '#c8d43a', '#bfde43', '#b6e84e', '#aff05b'
}

for i, fg in ipairs(gradient) do
  gradient[i] = wilder.make_hl('WilderGradient' .. i, 'Pmenu', { { a = 1 }, { a = 1 }, { foreground = fg } })
end

wilder.set_option('renderer', wilder.popupmenu_renderer({
  highlights = {
    gradient = gradient, -- must be set
    -- selected_gradient key can be set to apply gradient highlighting for the selected candidate.
  },
  highlighter = wilder.highlighter_with_gradient({
    wilder.basic_highlighter(), -- or wilder.lua_fzy_highlighter(),
  }),
}))
