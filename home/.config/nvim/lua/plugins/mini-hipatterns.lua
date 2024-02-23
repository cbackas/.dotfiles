return {
  'echasnovski/mini.hipatterns',
  version = '*',
  config = function()
    local hipatterns = require('mini.hipatterns')
    hipatterns.setup({
      highlighters = {
        -- Highlight standalone 'TODO', 'NOTE'
        -- todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        -- note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
      delay = {
        -- How much to wait for update after every text change
        text_change = 200,
        -- How much to wait for update after window scroll
        scroll = 50,
      },
    })
  end
}
